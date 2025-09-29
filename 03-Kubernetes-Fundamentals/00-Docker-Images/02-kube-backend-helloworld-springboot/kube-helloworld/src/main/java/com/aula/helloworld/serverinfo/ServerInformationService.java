package com.aula.helloworld.serverinfo;

import org.springframework.stereotype.Service;

@Service
public class ServerInformationService {
    
    public String getServerInfo() {
        return "from Spring Boot Application";
    }
}

