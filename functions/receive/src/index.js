import AWS from 'aws-sdk';
import getObjectContent from './getObjectContent';

export const handle = async function(e, ctx, cb) {
  const sesNotification = e.Records[0].ses;

  try {
    const response = await getObjectContent(sesNotification.mail.messageId);
    cb(null, response);
    return;
  } catch(err) {
    cb(err);
  }
}
