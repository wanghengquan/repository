package utility_funcs;
 
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Base64.Encoder;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import data_center.public_data;


public class des_encode {
    private final static String DES = "DES";
    //public final static String key = "@Lattice";

    /**
     * Description
     * @param data 
     * @param key
     * @return
     * @throws Exception
     */

	public static String encrypt(String data, String key) throws Exception {
        byte[] bt = encrypt(data.getBytes(), key.getBytes());
        Encoder encoder = Base64.getEncoder();
        String result = encoder.encodeToString(bt);
        return result;
    }

    /**
     * Description
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    private static byte[] encrypt(byte[] data, byte[] key) throws Exception {

        SecureRandom sr = new SecureRandom();
        DESKeySpec dks = new DESKeySpec(key);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
        SecretKey securekey = keyFactory.generateSecret(dks);
        Cipher cipher = Cipher.getInstance(DES);
        cipher.init(Cipher.ENCRYPT_MODE, securekey, sr);
        return cipher.doFinal(data);
    }
    
    public static void main(String[] args) throws Exception {
        String data = "public_+_lattice";
        System.out.println(encrypt(data, public_data.ENCRY_KEY));
    }
}