function handler(event) {
  var request = event.request;
  console.log('original uri: ' + request.uri);
  request.uri = '/index.html';
  return request;
}
