DROP DATABASE BIBLIOTECA;

CREATE DATABASE BIBLIOTECA;

USE BIBLIOTECA

#
#	CREAZIONE TABELLE PER LE ENTITà
#

CREATE TABLE Utente (
	id_utente    			INT AUTO_INCREMENT PRIMARY KEY ,
	email 		 			VARCHAR(100) NOT NULL ,
	password	 			VARCHAR(100) NOT NULL ,
	tipo		 			VARCHAR(10)  NOT NULL DEFAULT 'PASSIVO',
	num_inserimenti 		INT DEFAULT 0, 	

	CONSTRAINT UNICA_EMAIL 	UNIQUE(email)
);

CREATE TABLE Anagrafica (
	id_utente  				INT PRIMARY KEY,
	nome  		 			VARCHAR(100) NOT NULL,
	cognome		 			VARCHAR(100) NOT NULL,	
	cf		 				VARCHAR(100) NOT NULL,
	data_nascita  			DATE	     NOT NULL,
	luogo_nascita 			VARCHAR(100) NOT NULL,
	nazionalita		 		VARCHAR(100) NOT NULL,
	
	CONSTRAINT ANAGRAFICA_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE CASCADE,
	CONSTRAINT UNICA_ANAGRAFICA UNIQUE(cf)
);

CREATE TABLE Pubblicazione (
	id_pubblicazione 		INT AUTO_INCREMENT PRIMARY KEY,
	titolo		 			VARCHAR(100) NOT NULL,
	data_inserimento 		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	data_ultima_modifica 	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	categoria 				VARCHAR(100) NOT NULL,
	numlike		 			INT DEFAULT 0,
	rif_inserimento 		INT,
	CONSTRAINT PUBBLICAZIONE_UTENTE FOREIGN KEY (rif_inserimento) REFERENCES Utente(id_utente) 	# decidereondelete
);

CREATE TABLE Metadati (
	id_pubblicazione		INT PRIMARY KEY,
	edizione				INT NOT NULL,
	data_pubblicazione 		DATE ,
	parole_chiave			varchar(200),
	isbn					INT(13),
	num_pagine				INT,
	lingua					VARCHAR(50),
	sinossi					VARCHAR(1000),
	CONSTRAINT METADATI_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT UNICO_ISBN UNIQUE(isbn)
);



CREATE TABLE Autore (
	id_autore 				INT AUTO_INCREMENT PRIMARY KEY,
	nome 					VARCHAR(100) NOT NULL ,
	cognome 				VARCHAR(100) NOT NULL
);

CREATE TABLE Capitolo (
	id_pubblicazione 		INT PRIMARY KEY,
	titolo					VARCHAR(100) NOT NULL,
	descrizione				VARCHAR(500) ,
	num_capitolo			INT,
	CONSTRAINT CAPITOLO_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione)
);

CREATE TABLE Versione_Stampa (
	id_pubblicazione 		INT PRIMARY KEY,
	num_copie 				INT NOT NULL,
	data_stampa				DATE,
	CONSTRAINT VERSIONESTAMPA_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione)
);


CREATE TABLE Mediatype (
	id_mediatype 			INT AUTO_INCREMENT PRIMARY KEY ,
	tipo					VARCHAR(200) NOT NULL,
	formato					VARCHAR(200) NOT NULL
);

CREATE TABLE Risorse (
	id_risorsa 				INT AUTO_INCREMENT PRIMARY KEY,
	id_mediatype			INT NOT NULL,
	uri						VARCHAR(200) NOT NULL,
	descrizione				VARCHAR(500),
	CONSTRAINT RISORSE_MEDIATYPE FOREIGN KEY(id_mediatype) REFERENCES Mediatype(id_mediatype)
);


#
#CREAZIONE TABELLE PER RELAZIONI
#

CREATE TABLE Recensione (
	id_utente				INT NOT NULL,
	id_pubblicazione 		INT NOT NULL,
	data 					TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
	stato 					VARCHAR(10) NOT NULL DEFAULT 'IN ATTESA',
	testo 					VARCHAR(500) ,
	CONSTRAINT RECENSIONE_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT RECENSIONE_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente(id_utente),
	CONSTRAINT UNICA_RECENSIONE UNIQUE(id_utente , id_pubblicazione)
);

	
CREATE TABLE Gradimento (
	id_utente				INT NOT NULL,
	id_pubblicazione 		INT NOT NULL,
	data			 		TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT GRADIMENTO_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente (id_utente) ON DELETE CASCADE,
	CONSTRAINT GRADIMENTO_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT UNICO_LIKE UNIQUE(id_utente,id_pubblicazione)
);


CREATE TABLE LOG (

	id_utente 				INT NOT NULL,
	id_pubblicazione		INT NOT NULL,
	data					TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
	descrizione				VARCHAR(100) NOT NULL,
	operazione 				VARCHAR(20) NOT NULL,
	CONSTRAINT LOG_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente (id_utente),
	CONSTRAINT LOG_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione)
);


CREATE TABLE Attribuzione(
	id_pubblicazione 		INT NOT NULL,
	id_autore 				INT NOT NULL,
	CONSTRAINT ATTRIBUZIONE_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT ATTRIBUZIONE_AUTORE FOREIGN KEY (id_autore) REFERENCES Autore(id_autore),
	CONSTRAINT UNICA_ATTRIBUZIONE UNIQUE(id_pubblicazione, id_autore)
);


CREATE TABLE LINK (
	id_pubblicazione 		INT NOT NULL,
	id_risorsa				INT NOT NULL,
	CONSTRAINT LINK_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT LINK_RISORSA FOREIGN KEY (id_risorsa) REFERENCES Risorse(id_risorsa)	
);



