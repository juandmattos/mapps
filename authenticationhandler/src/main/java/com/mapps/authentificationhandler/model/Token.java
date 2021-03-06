package com.mapps.authentificationhandler.model;

import java.util.Date;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.encryption.Encrypter;
import com.mapps.authentificationhandler.encryption.exception.ErrorInDecryptionException;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;

/**
 * Represents a token
 */
public class Token {

    String username;
    String password;
    long createdAt;
    static Encrypter encrypter = new Encrypter();
    private static Logger logger = Logger.getLogger(Token.class);

    public Token(String username, String password, long createdAt) {
        this.username = username;
        this.password = password;
        this.createdAt = createdAt;
    }

    public Token(String username, String password) {
        this.username = username;
        this.password = password;
        this.createdAt = (new Date()).getTime();
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    @Override
    public String toString() {
       String decrypted = Long.toString(this.createdAt)+"@"+this.username+"@"+this.password;
       return encrypter.encrypt(decrypted);
    }

    public static Token getToken(String token) throws InvalidTokenException {
        try {
            String decrypted = encrypter.decrypt(token);
            String[] pieces = decrypted.split("@",4);
            String s = pieces[0];
            long createdAt = Long.valueOf(s);
            String username = pieces[1];
            String password = pieces[2];
            return new Token(username,password,createdAt);
        } catch (ErrorInDecryptionException e) {
            logger.warn("getToken token not valid");
            throw new InvalidTokenException();
        }
    }

}
