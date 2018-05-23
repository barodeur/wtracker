const AWS = require('aws-sdk');
const s3 = new AWS.S3();

const bucketName = 'fr.chobert.wtrakcer.emails';

exports.handle = function(e, ctx, cb) {
  console.log('processing event: %j', e);
  const sesNotification = e.Records[0].ses;
  s3.getObject({
    Bucket: bucketName,
    Key: sesNotification.mail.messageId,
  }, (err, data) => {
    if (err) {
      cb(err);
    } else {
      cb(null, { body: data.Body.toString() });
    }
  });
}
