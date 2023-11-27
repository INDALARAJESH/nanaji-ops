import argparse
import boto3
import mimetypes
import os

# python3 s3dirupload.py --rolearn "arn:aws:iam::731031120404:role/OrganizationAccountAccessRole" --destinationbucket "gdpr-redirect-qa" --sourcedirectory '/Users/jonathan.le/dev/chownow/ops-tf-modules/gdpr-redirect/assets'

# Get CLI Arguments
parser = argparse.ArgumentParser(description='Upload directory to S3.')
parser.add_argument('--sourcedirectory',
                    help='Full path to directory to be uploaded.', type=str)
parser.add_argument('--destinationbucket',
                    help='S3 Bucket destination name.', type=str)
parser.add_argument(
    '--rolearn', help='Role ARN to assume to for destination ENV', type=str)
args = parser.parse_args()

# Inspired by https://gist.github.com/ozgurakan/e508202f713e875058283b84cc4e2483
# If a role_arn is supplied, use that assumed role, otherwise, grab the AWS keys from the Environment


def aws_session(role_arn=None, session_name='my_session'):
    """
    If role_arn is given assumes a role and returns boto3 session
    otherwise return a regular session with the current IAM user/role
    """
    if role_arn:
        client = boto3.client('sts')
        response = client.assume_role(
            RoleArn=role_arn, RoleSessionName=session_name)
        session = boto3.Session(
            aws_access_key_id=response['Credentials']['AccessKeyId'],
            aws_secret_access_key=response['Credentials']['SecretAccessKey'],
            aws_session_token=response['Credentials']['SessionToken']
        )
        return session
    else:
        return boto3.Session()


def upload_files(path):
    session_assumed = aws_session(role_arn=args.rolearn, session_name='my_s3')

    s3 = session_assumed.resource('s3')
    bucket = s3.Bucket(args.destinationbucket)

    for subdir, dirs, files in os.walk(path):
        for file in files:
            full_path = os.path.join(subdir, file)
            file_mime = mimetypes.guess_type(file)[0] or 'binary/octet-stream'
            with open(full_path, 'rb') as data:
                bucket.put_object(Key=full_path[len(path) + 1:], Body=data, ContentType=file_mime)


if __name__ == "__main__":
    upload_files(args.sourcedirectory)
