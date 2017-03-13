package utility_funcs;
 
import java.io.IOException;
import java.security.SecureRandom;
 
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
 
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
 
@SuppressWarnings({ "restriction", "unused" })
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
		BASE64Decoder decoder = new BASE64Decoder();
        byte[] buf = decoder.decodeBuffer(data);
        byte[] bt = decrypt(buf,key.getBytes());
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
        String data = "GlfbE2rHHgT9xCSyNcCsuA==";
        System.err.println(decrypt(data, "@Lattice"));
    }    
}