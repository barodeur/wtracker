import AWS from 'aws-sdk';

const s3 = new AWS.S3();
const bucketName = 'fr.chobert.wtrakcer.emails';

export default async (key) => new Promise((resolve, reject) => {
    s3.getObject({
      Bucket: bucketName,
      Key: key,
    }, (err, data) => {
      if (err) {
        reject(err);
        return;
      }

      resolve(data.Body.toString())
    });
  });
