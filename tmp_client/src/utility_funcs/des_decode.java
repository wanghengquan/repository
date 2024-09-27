package utility_funcs;
 
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Base64.Decoder;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import data_center.public_data;

 
public class des_decode {
 
    private final static String DES = "DES";
    //protected final static String key = "@Lattice";
 
    /**
     * Description
     * @param data
     * @param key
     * @return
     * @throws IOException
     * @throws Exception
     */
	public static String decrypt(String data, String key) throws IOException,
            Exception {
        if (data == null)
            return null;
        Decoder decoder = Base64.getDecoder();
        byte[] result = decoder.decode(data);
        byte[] bt = decrypt(result,key.getBytes());
        return new String(bt);
    }
    
    /**
     * Description
     * @param data
     * @param key 
     * @return
     * @throws Exception
     */
    private static byte[] decrypt(byte[] data, byte[] key) throws Exception {
        SecureRandom sr = new SecureRandom();
        DESKeySpec dks = new DESKeySpec(key);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
        SecretKey securekey = keyFactory.generateSecret(dks);
        Cipher cipher = Cipher.getInstance(DES);
        cipher.init(Cipher.DECRYPT_MODE, securekey, sr);
        return cipher.doFinal(data);
    }
    
    public static void main(String[] args) throws Exception {
        //String data = "Yjt7LEio8/fYJFFTV2UcnpIfxN5656MO";
        String data = "mWz8BslYuSBDfJMUWfk/UB5jDoQSlk79";
        System.err.println(decrypt(data, public_data.ENCRY_KEY));
    }    
}