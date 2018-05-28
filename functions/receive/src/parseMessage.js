import { simpleParser } from 'mailparser';

export default async (message) => {
  const mail = await simpleParser(message);
  const content =  mail.text.trim();
  return Number(content.match(/(\d+)([.,]\d+)?/)[0].replace(',', '.'));
}
