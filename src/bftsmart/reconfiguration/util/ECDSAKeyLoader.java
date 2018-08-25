package bftsmart.reconfiguration.util;

import bftsmart.tom.util.KeyLoader;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.CertificateException;
import java.security.spec.EncodedKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import org.apache.commons.codec.binary.Base64;

/**
 * Used to load JCA public and private keys from conf/keys/publickey<id> and
 * conf/keys/privatekey<id>
 */
public class ECDSAKeyLoader implements KeyLoader {

    private String path;
    private int id;
    private PrivateKey priKey;

    private String sigAlgorithm;

    private static String DEFAULT_UKEY = 
        "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEZbmaUJjW8rGElczT0qDj3ipX7ylK" +
        "82u9OtaEb8DI/vfVE8ERoARni8Ug4Qh+sGlqYyapO62MS/8dmpGT1gPqcw==";

    private static String DEFAULT_PKEY =
        "MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQg+U849sY3fwEtloGwKUhOf828rple" +
        "6N+NSHVwCbSBQAyhRANCAARluZpQmNbysYSVzNPSoOPeKlfvKUrza7061oRvwMj9V9UTwRGgBGeL" +
        "xSDhCH6waWpjJqk7rYxL/x2akZPWA+pz";

    private boolean defaultKeys;

    /** Creates a new instance of ECDSAKeyLoader */
    public ECDSAKeyLoader(int id, String configHome, boolean defaultKeys, String sigAlgorithm) {

            this.id = id;
            this.defaultKeys = defaultKeys;
            this.sigAlgorithm = sigAlgorithm;
            
            if (configHome.equals("")) {
                    path = "config" + System.getProperty("file.separator") + "keys" +
                                    System.getProperty("file.separator");
            } else {
                    path = configHome + System.getProperty("file.separator") + "keys" +
                                    System.getProperty("file.separator");
            }
    }

    /**
     * Loads the public key of some processes from configuration files
     *
     * @return the PublicKey loaded from config/keys/publickey<id>
     * @throws Exception problems reading or parsing the key
     */
    public PublicKey loadPublicKey(int id) throws IOException, NoSuchAlgorithmException, InvalidKeySpecException, CertificateException {
        return getPublicKeyFromString(ECDSAKeyLoader.DEFAULT_UKEY);
    }

    public PublicKey loadPublicKey() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException, CertificateException {
        return getPublicKeyFromString(ECDSAKeyLoader.DEFAULT_UKEY);
    }

    /**
     * Loads the private key of this process
     *
     * @return the PrivateKey loaded from config/keys/publickey<conf.getProcessId()>
     * @throws Exception problems reading or parsing the key
     */
    public PrivateKey loadPrivateKey() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        return getPrivateKeyFromString(ECDSAKeyLoader.DEFAULT_PKEY);
    }

    //utility methods for going from string to public/private key
    private PrivateKey getPrivateKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        //try {
            KeyFactory keyFactory = KeyFactory.getInstance("EC");
            EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(Base64.decodeBase64(key));
            PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);
            return privateKey;
        //} catch (NoSuchProviderException e) {
        //    throw new NoSuchAlgorithmException(e.toString());
        //}
    }

    private PublicKey getPublicKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        //try {
            KeyFactory keyFactory = KeyFactory.getInstance("EC");
            EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(Base64.decodeBase64(key));
            PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);
            return publicKey;
        //} catch (NoSuchProviderException e) {
        //    throw new NoSuchAlgorithmException(e.toString());
        //}
    }

    @Override
    public String getSignatureAlgorithm() {
        
        return this.sigAlgorithm;
    }
}
