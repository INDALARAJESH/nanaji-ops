import boto3,os

RETAIN = 10 # number of artifacts (dirs/folders) to retain
PREFIX = 'build-' # string prefixed to relevant object paths

if os.environ.get('RETAIN'):
    RETAIN = int(os.environ['RETAIN'])
if os.environ.get('PREFIX'):
    PREFIX = os.environ['PREFIX']

def handler(event, context):
    # boto3 object resources don't handle listing the way we want :(
    s3 = boto3.client("s3")
    # Get bucket that triggered me
    print(event)
    BUCKET = event['Records'][0]['s3']['bucket']['name']
    print("Cleanup triggered by BUCKET *{}*, retaining *{}* with prefix *{}*".format(BUCKET, RETAIN, PREFIX))

    listing = s3.list_objects_v2(Bucket=BUCKET,Prefix=PREFIX, Delimiter='/')
    keys = [ x['Prefix'] for x in listing['CommonPrefixes']]
    if len(keys)>RETAIN:
        keys.sort(reverse = True)
        discard = keys[RETAIN:]
        s3 = boto3.resource("s3")
        bucket = s3.Bucket(BUCKET)
        for k in discard:
            objects = bucket.objects.filter(Prefix=k)
            for o in objects:
                print("DELETING {}".format(o))
                o.delete()
