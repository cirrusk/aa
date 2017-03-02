package amway.com.academy.manager.common.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

/**
 * Created by KR620242 on 2016-12-06.
 */
public class PropertiesReader {

    public String getProperties(String key) {
        Properties ppt = new Properties();
        String propertyFil = "/config/message/message-common.properties";
        try {
            FileInputStream in = new FileInputStream(propertyFil);
            ppt.load(in);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String result = ppt.getProperty(key);
        return result;
    }

    public void setProperties(String propertyFile, String keyname, String value) {
        try {
            Properties props = new Properties();
            FileInputStream fis = new FileInputStream(propertyFile);
            props.load(fis);
            props.setProperty(keyname, value);
            props.store(new FileOutputStream(propertyFile), "");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
