import util from 'util';
import fs from 'fs';
import parseMessage from './parseMessage';

const readFile = util.promisify(fs.readFile);

test('it parses the email and return the number found', async () => {
  const data = await readFile(`${__dirname}/message_test.eml`);
  const message = data.toString();
  expect(await parseMessage(message)).toBe(1.42);
});
