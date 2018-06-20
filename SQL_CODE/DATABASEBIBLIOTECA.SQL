DROP DATABASE BIBLIOTECA;

CREATE DATABASE BIBLIOTECA;

USE BIBLIOTECA

CREATE TABLE Utente (
	email 		 VARCHAR(100) PRIMARY KEY,
	password	 VARCHAR(100) NOT NULL,
	tipo		 VARCHAR(10)  NOT NULL DEFAULT 'PASSIVO'
);

CREATE TABLE Anagrafica (
	email		 VARCHAR(100) NOT NULL PRIMARY KEY,
	nome  		 VARCHAR(100) NOT NULL,
	cognome		 VARCHAR(100) NOT NULL,	
	cf		 VARCHAR(100) NOT NULL,
	data_di_nascita  DATE	      NOT NULL,
	luogo_di_nascita VARCHAR(100) NOT NULL,
	nazione		 VARCHAR(100) NOT NULL,
	CONSTRAINT ANAGRAFICA_UTENTE FOREIGN KEY (email) REFERENCES Utente(email) ON DELETE CASCADE,
	CONSTRAINT UNICA_ANAGRAFICA UNIQUE(nome,cognome,cf,data_di_nascita,luogo_di_nascita,nazione)
);

CREATE TABLE Storico (
	id_storico	 INT AUTO_INCREMENT PRIMARY KEY,
	utente		 VARCHAR(100) NOT NULL,
	data_operazione	 TIMESTAMP    DEFAULT CURRENT_TIMESTAMP, 
	descrizione	 VARCHAR(300) NOT NULL,
	CONSTRAINT STORICO_UTENTE FOREIGN KEY (utente) REFERENCES Utente(email) ON DELETE CASCADE
);

CREATE TABLE Autore (
	id_autore 	INT AUTO_INCREMENT PRIMARY KEY,
	nome		VARCHAR(100) NOT NULL,
	cognome		VARCHAR(100) NOT NULL,
	CONSTRAINT AUTORE_UNICO UNIQUE(nome,cognome)
);

CREATE TABLE Pubblicazione(
	id_pubblicazione INT AUTO_INCREMENT PRIMARY KEY,
	titolo		 VARCHAR(100) NOT NULL,
	editore		 VARCHAR(100) NOT NULL,
	data_inserimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	numlike		 INT default 0,
	CONSTRAINT PUBBLICAZIONE_UNICA UNIQUE(titolo,editore)
);


CREATE TABLE Pubblicata (
	
	id_pubblicazione INT,
	email VARCHAR(100),
	CONSTRAINT PUBBLICAZIONERIFERITA	 FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT PUBBLICAZIONEINSERITADAUTENTE FOREIGN KEY (email) REFERENCES Utente(email) ON DELETE CASCADE,
	CONSTRAINT UNICAPUBBLICATA UNIQUE(id_pubblicazione , email )
);


CREATE TABLE Edizione (
	isbn		INT NOT NULL PRIMARY KEY,
	pubblicazione	INT NOT NULL,
	numero_pagine	INT NOT NULL,
	lingua		VARCHAR(20) NOT NULL,
	parole_chiave	varchar(1000) NOT NULL,
	data 		DATE NOT NULL,
	CONSTRAINT  EDIZIONE_PUBBLICAZIONE FOREIGN KEY (pubblicazione) REFERENCES Pubblicazione(id_pubblicazione) ON DELETE CASCADE
);

CREATE TABLE Indice (
	id		INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	edizione	INT NOT NULL,
	num_capitolo	INT NOT NULL,
	titolo_capitolo	VARCHAR(100) NOT NULL,
	CONSTRAINT INDICE_PUBBLICAZIONE FOREIGN KEY (edizione) REFERENCES Edizione(isbn) ON DELETE CASCADE,
	CONSTRAINT INDICE_UNICO	UNIQUE(edizione,num_capitolo)
);	


CREATE TABLE Ristampa (
	id		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	codice		INT NOT NULL ,
	edizione	INT NOT NULL ,
	data		DATE NOT NULL,
	numero 		INT NOT NULL,
	CONSTRAINT RISTAMPA_PUBBLICAZIONE FOREIGN KEY (edizione) REFERENCES Edizione(isbn) ON DELETE CASCADE,
	CONSTRAINT RISTAMPA_UNICA UNIQUE(codice,edizione)
);

CREATE TABLE Sorgente (
	id_sorgente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	tipo VARCHAR(50) NOT NULL,
	uri VARCHAR(100) NOT NULL,
	formato VARCHAR(100) NOT NULL,
	descrizione VARCHAR(300) NOT NULL
);

CREATE TABLE Collegamento (
	id_sorgente 	 INT NOT NULL,
	id_isbn INT NOT NULL,
	CONSTRAINT COLLEGAMENTI_SORGENTE FOREIGN KEY (id_sorgente) REFERENCES Sorgente(id_sorgente) ON DELETE CASCADE,
	CONSTRAINT COLLEGAMENTI_EDIZIONE FOREIGN KEY (id_isbn)     REFERENCES Edizione(isbn) ON DELETE CASCADE,
	CONSTRAINT COLLEGAMENTO_UNICO UNIQUE(id_sorgente,id_isbn)
);

CREATE TABLE Scritta (
	id_autore	 INT NOT NULL,
	id_pubblicazione INT NOT NULL,
	CONSTRAINT SCRITTA_AUTORE FOREIGN KEY (id_autore) REFERENCES Autore (id_autore) ON DELETE CASCADE,
	CONSTRAINT SCRITTA_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione (id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT UNICA_SCRITTA UNIQUE(id_autore,id_pubblicazione)
);

CREATE TABLE Recensione (
	id_recensione	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	pubblicazione	INT NOT NULL,
	utente		varchar(100) NOT NULL,
	data_inserimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
	stato 		VARCHAR(10) NOT NULL DEFAULT 'IN ATTESA',
	testo 		VARCHAR(500) ,
	CONSTRAINT RECENSIONE_UTENTE FOREIGN KEY (utente) REFERENCES Utente (email) ON DELETE CASCADE,
	CONSTRAINT RECENSIONE_PUBBLICAZIONE FOREIGN KEY (pubblicazione) REFERENCES Pubblicazione (id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT RECENSIONE_UNICA UNIQUE(pubblicazione,utente)
);


CREATE TABLE Gradimento (
	id_like		 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	utente		 VARCHAR(100) NOT NULL,
	id_pubblicazione INT NOT NULL,
	CONSTRAINT GRADIMENTO_UTENTE FOREIGN KEY (utente) REFERENCES Utente (email) ON DELETE CASCADE,
	CONSTRAINT GRADIMENTO_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT UNICO_GRADIMENTO UNIQUE(utente,id_pubblicazione)
);




			#################################################################
			# PROCEDURE PER TABELLA UTENTE					#
			#								#
			#	██╗   ██╗████████╗███████╗███╗   ██╗████████╗███████╗	#
			#	██║   ██║╚══██╔══╝██╔════╝████╗  ██║╚══██╔══╝██╔════╝	#
			#	██║   ██║   ██║   █████╗  ██╔██╗ ██║   ██║   █████╗  	#
			#	██║   ██║   ██║   ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  	#
			#	╚██████╔╝   ██║   ███████╗██║ ╚████║   ██║   ███████╗	#
			#	 ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝	#
			#								#
			#################################################################                                                     


#INSERIMENTO NUOVO UTENTE

DELIMITER $

CREATE PROCEDURE ADDUTENTE ( IN EMAIL VARCHAR(100), IN PASSWORD VARCHAR(100) ) 
	BEGIN
	INSERT INTO Utente(email,password) value ( EMAIL,PASSWORD);
	END $ 


# ELIMINAZIONE UTENTE DATA LA MAIL

CREATE PROCEDURE DELETEUTENTE (IN EMAIL VARCHAR(100) )
	BEGIN
		DELETE FROM Utente where email = EMAIL ;
	END $


# AGGIORNAMENTO PASSWORD

CREATE PROCEDURE UPDATEPASSWORD ( IN EMAIL VARCHAR(100),  IN PASSWORD VARCHAR(100)  ) 
	BEGIN
		UPDATE Utente SET password = PASSWORD WHERE email = EMAIL;
	END $
 

#AGGIORNAMENTO EMAIL

CREATE PROCEDURE UPDATEEMAIL ( IN EMAILVECCHIA VARCHAR(100), IN EMAILNUOVA VARCHAR(100)  )
	BEGIN
		UPDATE Utente SET email = EMAILNUOVA WHERE email = EMAILVECCHIA ;
	END $




		#########################################################################################
		# PROCEDURE PER TABELLA ANAGRAFICA							#
		#											#
		#											#
		#	 █████╗ ███╗   ██╗ █████╗  ██████╗ ██████╗  █████╗ ███████╗██╗ ██████╗ █████╗ 	#
		#	██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔════╝██║██╔════╝██╔══██╗	#
		#	███████║██╔██╗ ██║███████║██║  ███╗██████╔╝███████║█████╗  ██║██║     ███████║	#
		#	██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══██╗██╔══██║██╔══╝  ██║██║     ██╔══██║	#
		#	██║  ██║██║ ╚████║██║  ██║╚██████╔╝██║  ██║██║  ██║██║     ██║╚██████╗██║  ██║	#
		#	╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝	#
                #											#
		#########################################################################################                                                              





#INSERIRE UNA NUOVA ANAGRAFICA

CREATE PROCEDURE ADDANAGRAFICA 

(
	IN EMAIL VARCHAR(100),
	IN NOME  VARCHAR(100),
	IN COGNOME VARCHAR(100),
	IN CF VARCHAR(100),
	IN DATADINASCITA DATE,
	IN LUOGODINASCITA VARCHAR(100),
	IN NAZIONE VARCHAR(100)
)

	BEGIN
	INSERT INTO Anagrafica value (EMAIL,NOME,COGNOME,CF,DATADINASCITA,LUOGODINASCITA,NAZIONE) ;
	END $	

# ELIMINARE UN ANAGRAFICA

CREATE PROCEDURE DELETEANAGRAFICA ( IN EMAIL VARCHAR(100) )
	BEGIN
	DELETE FROM Anagrafica WHERE email = EMAIL ;
	END $


#PROCEDURE PER AGGIORNAMENTO

#UPDATE NOME

CREATE PROCEDURE UPDATENOME (IN NUOVONOME VARCHAR(100) , IN MAIL VARCHAR(100) )
	BEGIN
	UPDATE Anagrafica SET nome= NUOVONOME WHERE email = MAIL ;
	END $


#UPDATE COGNOME

CREATE PROCEDURE UPDATECOGNOME(IN NUOVOCOGNOME VARCHAR(100), IN MAIL VARCHAR(100) )
	BEGIN
        UPDATE Anagrafica SET cognome= NUOVOCOGNOME WHERE email = MAIL ;
        END $


#UPDATE CODICE FISCALE

CREATE PROCEDURE UPDATECF ( IN NUOVOCF VARCHAR(100) , IN MAIL VARCHAR(100) )
        BEGIN
        UPDATE Anagrafica SET cf = NUOVOCF WHERE email = MAIL ;
        END $


#UPDATE DATA DI NASCITA

CREATE PROCEDURE UPDATEDATADINASCITA (IN NUOVADATA Date, IN MAIL VARCHAR(100) )
        BEGIN
        UPDATE Anagrafica SET data_di_nascita= NUOVADATA WHERE email = MAIL ;
        END $


#UPDATE LUOGO DI NASCITA

CREATE PROCEDURE UPDATELUOGODINASCITA (IN NUOVOLUOGO VARCHAR(100), IN MAIL VARCHAR(100) )
        BEGIN
        UPDATE Anagrafica SET luogo_di_nascita = NUOVOLUOGO WHERE email = MAIL ;
        END $


#UPDATE NAZIONE
CREATE PROCEDURE UPDATENAZIONE (IN NUOVANAZIONE VARCHAR(100), IN MAIL VARCHAR(100) )
        BEGIN
        UPDATE Anagrafica SET nazione = NUOVANAZIONE WHERE email = MAIL ;
        END $



		#################################################################################################################
		# PROCEDURE TABELLA PUBBLICAZIONE										#
		#														#
		#														#
		#	██████╗ ██╗   ██╗██████╗ ██████╗ ██╗     ██╗ ██████╗ █████╗ ███████╗██╗ ██████╗ ███╗   ██╗███████╗	#
		#	██╔══██╗██║   ██║██╔══██╗██╔══██╗██║     ██║██╔════╝██╔══██╗╚══███╔╝██║██╔═══██╗████╗  ██║██╔════╝	#
		#	██████╔╝██║   ██║██████╔╝██████╔╝██║     ██║██║     ███████║  ███╔╝ ██║██║   ██║██╔██╗ ██║█████╗  	#
		#	██╔═══╝ ██║   ██║██╔══██╗██╔══██╗██║     ██║██║     ██╔══██║ ███╔╝  ██║██║   ██║██║╚██╗██║██╔══╝  	#
		#	██║     ╚██████╔╝██████╔╝██████╔╝███████╗██║╚██████╗██║  ██║███████╗██║╚██████╔╝██║ ╚████║███████╗	#
		#	╚═╝      ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝	#
		#														#
                #################################################################################################################                                                                           




#INSERIMENTO NUOVA PUBBLICAZIONE 

CREATE PROCEDURE ADDPUBBLICAZIONE (IN TITOLO VARCHAR(100) , IN EDITORE VARCHAR(100) )
	BEGIN
	INSERT INTO Pubblicazione (titolo,editore) VALUE ( TITOLO , EDITORE ) ;
	END $



#CANCELLARE UNA PUBBLICAZIONE DATO UN TITOLO

CREATE PROCEDURE DELETEPUBBLICAZIONE (IN TITOLO VARCHAR(100) )
	BEGIN
	DELETE FROM Pubblicazione WHERE titolo = TITOLO ;
	END $

#UPDATE TITOLO PUBBLICAZIONE

CREATE PROCEDURE UPDATETITOLO ( IN NUOVOTITOLO VARCHAR(100) , IN VECCHIOTITOLO VARCHAR(100) )
	BEGIN
	UPDATE Pubblicazione SET titolo = NUOVOTITOLO WHERE titolo = VECCHIOTITOLO ;
	END $

#UPDATE EDITORE PUBBLICAZIONE

CREATE PROCEDURE UPDATEEDITORE ( IN NUOVOEDITORE VARCHAR(100) , IN TITOLO VARCHAR(100) )
	BEGIN
	UPDATE Pubblicazione SET editore = NUOVOEDITORE WHERE titolo = TITOLO ;
	END $


#UPDATE NUMERO LIKE PUBBLICAZIONE

CREATE PROCEDURE UPDATENUMEROLIKE ( IN PUBBLICAZIONE INT )
        BEGIN
        UPDATE Pubblicazione SET numlike = numlike +1  WHERE id_pubblicazione = PUBBLICAZIONE ;
        END $


#######################################################################
# PROCEDURE PER TABELLA PUBBLICATA


#INSERIRE ASSOCIAZIONE PUBBLICAZIONE UTENTE

CREATE PROCEDURE ADDPUBBLICATA ( IN IDPUBBLICAZIONE INT , IN UTENTE VARCHAR(100) )
	BEGIN
	INSERT INTO Pubblicata VALUE ( IDPUBBLICAZIONE , UTENTE );
	END $


























		#########################################################################
		#									#
		#PROCEDURE EDIZIONE							#
		#									#
		#	███████╗██████╗ ██╗███████╗██╗ ██████╗ ███╗   ██╗███████╗	#
		#	██╔════╝██╔══██╗██║╚══███╔╝██║██╔═══██╗████╗  ██║██╔════╝	#
		#	█████╗  ██║  ██║██║  ███╔╝ ██║██║   ██║██╔██╗ ██║█████╗  	#
		#	██╔══╝  ██║  ██║██║ ███╔╝  ██║██║   ██║██║╚██╗██║██╔══╝  	#
		#	███████╗██████╔╝██║███████╗██║╚██████╔╝██║ ╚████║███████╗	#
		#	╚══════╝╚═════╝ ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝	#
                #                                         				#
		#########################################################################




#INSERIRE NUOVA EDIZIONE

CREATE PROCEDURE ADDEDIZIONE
(
	IN ISBN   	INT,
	IN ID_PUBB	INT,
	IN NUMPAGINE 	INT,  
	IN LINGUA	VARCHAR(20),
	IN PAROLECHIAVE VARCHAR(1000),
	IN DATE		Date
)

	BEGIN
	INSERT INTO Edizione VALUE ( ISBN , ID_PUBB , NUMPAGINE , LINGUA , PAROLECHIAVE , DATE );
	END $


#DELETE EDIZIONE
CREATE PROCEDURE DELETEEDIZIONE ( IN ISBN INT ) 
	BEGIN
	DELETE FROM Edizione WHERE isbn = ISBN ;
	END $

#UPDATE ISBN
CREATE PROCEDURE UPDATEISBN ( IN NUOVOISBN INT , IN VECCHIOISBN INT )
	BEGIN
	UPDATE Edizione SET isbn = NUOVOISBN WHERE isbn = VECCHIOISBN ;
	END $

#UPDATE NUMERO PAGINE
CREATE PROCEDURE UPDATENUMEROPAGINE ( IN NUMPAGINE INT , IN ISBN INT )
        BEGIN
	UPDATE Edizione SET numero_pagine = NUMPAGINE WHERE isbn = ISBN ;
        END $


#UPDATE LINGUA
CREATE PROCEDURE UPDATELINGUA (IN LINGUA VARCHAR(20) , IN ISBN INT )
        BEGIN
	UPDATE Edizione SET lingua = LINGUA WHERE isbn = ISBN ;
        END $


#UPDATE PAROLECHIAVE
CREATE PROCEDURE UPDATEPAROLECHIAVE (IN PAROLECHIAVE VARCHAR(1000) , IN ISBN INT )
        BEGIN
	UPDATE Edizione SET parole_chiave = PAROLECHIAVE WHERE isbn = ISBN ;
        END $


#UPDATE DATE EDIZIONE
CREATE PROCEDURE UPDATEDATAEDIZIONE (IN DATA Date , IN ISBN INT )
        BEGIN
	UPDATE Edizione SET data = DATA WHERE isbn = ISBN ;
        END $

		#########################################
		# PROCEDURE LIKE/GRADIMENTO		#
		#					#
		#	██╗     ██╗ ██╗  ██╗ ███████╗	#
		#	██║     ██║ ██║ ██╔╝ ██╔════╝	#
		#	██║     ██║ █████╔╝  █████╗  	#
		#	██║     ██║ ██╔═██╗  ██╔══╝  	#
		#	███████╗██║ ██║  ██╗ ███████╗	#
		#	╚══════╝╚═╝ ╚═╝  ╚═╝ ╚══════╝	#
                #########################################       

# AGGIUNTA LIKE
CREATE PROCEDURE ADDLIKE ( IN UTENTE VARCHAR(100) , IN IDPUBBLICAZIONE INT )
        BEGIN
	INSERT INTO Gradimento (utente , id_pubblicazione ) VALUE ( UTENTE , IDPUBBLICAZIONE );
        END $

#DELETE LIKE/GRADIMENTO
CREATE PROCEDURE DELETELIKE (IN UTENTE VARCHAR(100) , IN IDPUBBLICAZIONE INT )
        BEGIN
	DELETE FROM Gradimento WHERE utente = UTENTE AND id_pubblicazione = IDPUBBLICAZIONE ; 
        END $



		#################################################################
		# PROCEDURE AUTORE						#
		#								#
		#	 █████╗ ██╗   ██╗████████╗ ██████╗ ██████╗ ███████╗	#
		#	██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝	#
		#	███████║██║   ██║   ██║   ██║   ██║██████╔╝█████╗  	#
		#	██╔══██║██║   ██║   ██║   ██║   ██║██╔══██╗██╔══╝  	#
		#	██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║  ██║███████╗	#
		#	╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝	#
                #################################################################                                 




# INSERIMENTO AUTORE
CREATE PROCEDURE ADDAUTORE (IN NOME VARCHAR(100) , IN COGNOME VARCHAR(100) )
        BEGIN
	INSERT INTO Autore ( nome , cognome ) VALUE ( NOME , COGNOME );
        END $

#RIMOZIONE AUTORE
CREATE PROCEDURE DELETEAUTORE(IN IDAUTORE INT )
        BEGIN
	DELETE FROM Autore WHERE id_autore = IDAUTORE ;
        END $


#MODIFICA NOME AUTORE
CREATE PROCEDURE UPDATENOMEAUTORE ( IN NUOVONOME VARCHAR(100) , IN IDAUTORE INT ) 
        BEGIN
	UPDATE Autore SET nome = NUOVONOME WHERE id_autore = IDAUTORE ;
        END $


#MODIFICA COGNOME AUTORE
CREATE PROCEDURE UPDATECOGNOMEAUTORE ( IN NUOVOCOGNOME VARCHAR(100) , IN IDAUTORE INT)
        BEGIN
        UPDATE Autore SET cognome = NUOVOCOGNOME WHERE id_autore = IDAUTORE ;
        END $



		#################################################################
		#PROCEDURE TABELLA SCRITTA					#
		#								#
		#	███████╗ ██████╗██████╗ ██╗████████╗████████╗ █████╗ 	#
		#	██╔════╝██╔════╝██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔══██╗	#
		#	███████╗██║     ██████╔╝██║   ██║      ██║   ███████║	#
		#	╚════██║██║     ██╔══██╗██║   ██║      ██║   ██╔══██║	#
		#	███████║╚██████╗██║  ██║██║   ██║      ██║   ██║  ██║	#
		#	╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝	#
		#								#
		#################################################################                                                     







#INSERIMENTO AUTORE-PUBBLICAZIONE

CREATE PROCEDURE ADDPUBBLICAZIONESCRITTADAAUTORE ( IN IDPUBBLICAZIONE INT , IN IDAUTORE INT )
        BEGIN
        INSERT INTO Scritta VALUE (IDAUTORE , IDPUBBLICAZIONE ); 
        END $

#CANCELLAZIONE AUTORE-PUBBLICAZIONE

CREATE PROCEDURE DELETEPUBBLICAZIONESCRITTADAAUTORE(IN IDPUBBLICAZIONE INT , IN IDAUTORE INT )
	BEGIN
	DELETE FROM Scritta WHERE id_autore = IDAUTORE AND id_pubblicazione = IDPUBBLICAZIONE ;
	END $


		#################################################################################
		#PROCEDURE TABELLA SORGENTE 							#
		#										#
		#	███████╗ ██████╗ ██████╗  ██████╗ ███████╗███╗   ██╗████████╗███████╗	#
		#	██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██╔════╝	#
		#	███████╗██║   ██║██████╔╝██║  ███╗█████╗  ██╔██╗ ██║   ██║   █████╗  	#
		#	╚════██║██║   ██║██╔══██╗██║   ██║██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  	#
		#	███████║╚██████╔╝██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ███████╗	#
		#	╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝	#
                #################################################################################                                                    


#INSERIMENTO SORGENTE

CREATE PROCEDURE ADDSORGENTE 
(
	IN TIPO VARCHAR(50),
	IN URI VARCHAR(100),
	IN FORMATO VARCHAR(100),
	IN DESCRIZIONE VARCHAR(300)
)
	BEGIN
	INSERT INTO Sorgente(tipo, uri,formato,descrizione) VALUE ( TIPO , URI , FORMATO , DESCRIZIONE );
	END $


#DELETE SORGENTE

CREATE PROCEDURE DELETESORGENTE(IN IDSORGENTE INT )
	BEGIN 
	DELETE FROM Sorgente WHERE id_sorgente = IDSORGENTE ;
	END $



#MODIFICA TIPO SORGENTE
CREATE PROCEDURE UPDATETIPOSORGENTE (IN TIPO VARCHAR(50) , IN IDSORGENTE INT ) 
        BEGIN
	UPDATE Sorgente SET tipo = TIPO WHERE id_sorgente = IDSORGENTE ;
        END $



#MODIFICA URI SORGENTE
CREATE PROCEDURE UPDATEURISORGENTE ( IN URI VARCHAR(100) , IN IDSORGENTE INT )
        BEGIN
	UPDATE Sorgente SET uri = URI WHERE id_sorgente = IDSORGENTE ;
        END $

#MODIFICA FORMATO SORGENTE

CREATE PROCEDURE UPDATEFORMATOSORGENTE ( IN FORMATO VARCHAR(100) , IN IDSORGENTE INT ) 
        BEGIN
	UPDATE Sorgente SET formato = FORMATO WHERE id_sorgente = IDSORGENTE ;
        END $


#MODIFICA DESCRIZIONE SORGENTE

CREATE PROCEDURE UPDATEDESCRIZIONESORGENTE ( IN DESCRIZIONE VARCHAR(300) , IN IDSORGENTE INT ) 
        BEGIN
	UPDATE Sorgente SET descrizione = DESCRIZIONE WHERE id_sorgente = IDSORGENTE ;
        END $



		#########################################################################################################################
		# PROCEDURE TABELLA COLLEGAMENTO (SORGENTE-PUBBLICAZIONE)								#
		#															#
		#	 ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗  █████╗ ███╗   ███╗███████╗███╗   ██╗████████╗ ██████╗ 	#
		#	██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝ ██╔══██╗████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗	#
		#	██║     ██║   ██║██║     ██║     █████╗  ██║  ███╗███████║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║	#
		#	██║     ██║   ██║██║     ██║     ██╔══╝  ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██║   ██║	#
		#	╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ╚██████╔╝	#
		#	 ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ 	#
		#															#
		#########################################################################################################################                                                                                                     
                                                                                                                                                            
                                                                                                         
                                                                                                         
                                                                                                         
                                                                                                      
#INSERIMENTO COLLEGAMENTO
CREATE PROCEDURE ADDCOLLEGAMENTO ( IN IDSORGENTE INT , IN IDPUBBLICAZIONE INT ) 
        BEGIN
	INSERT INTO Collegamento VALUE (IDSORGENTE , IDPUBBLICAZIONE );
        END $

#ELIMINAZIONE COLLEGAMENTO
CREATE PROCEDURE DELETECOLLEGAMENTO (IN IDSORGENTE INT , IN IDPUBBLICAZIONE INT )
	BEGIN
	DELETE FROM Collegamento WHERE id_sorgente = IDSORGENTE AND id_pubblicazione = IDPUBBLICAZIONE ;
	END $

 


		#########################################################
		#							#
		#	██╗███╗   ██╗██████╗ ██╗ ██████╗███████╗	#
		#	██║████╗  ██║██╔══██╗██║██╔════╝██╔════╝	#
		#	██║██╔██╗ ██║██║  ██║██║██║     █████╗  	#
		#	██║██║╚██╗██║██║  ██║██║██║     ██╔══╝  	#
		#	██║██║ ╚████║██████╔╝██║╚██████╗███████╗	#
		#	╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝ ╚═════╝╚══════╝	#
		#							#
		#########################################################





#INSERIRE INDICE 

CREATE PROCEDURE ADDINDICE 
(
IN EDIZIONE   		INT,
IN NUMCAPITOLO		INT,
IN TITOLOCAPITOLO 	VARCHAR(100)	
)

	BEGIN
	INSERT INTO Indice (edizione , num_capitolo ,titolo_capitolo) VALUE ( EDIZIONE , NUMCAPITOLO , TITOLOCAPITOLO );
	END $


#DELETE INDICE
CREATE PROCEDURE DELETEINDICE( IN ID INT ) 
	BEGIN
	DELETE FROM Indice WHERE id = ID ;
	END $


#MODIFICA TITOLO CAPITOLO

CREATE PROCEDURE UPDATETITOLOCAPITOLO (IN TITOLO VARCHAR(100) , IN ID INT )
	BEGIN
	UPDATE Indice SET titolo_capitolo = TITOLO WHERE id = ID ;
	END $




		#################################################################################
		#										#
		#	██████╗ ██╗███████╗████████╗ █████╗ ███╗   ███╗██████╗  █████╗ 		#
		#	██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗████╗ ████║██╔══██╗██╔══██╗		#
		#	██████╔╝██║███████╗   ██║   ███████║██╔████╔██║██████╔╝███████║		#
		#	██╔══██╗██║╚════██║   ██║   ██╔══██║██║╚██╔╝██║██╔═══╝ ██╔══██║		#
		#	██║  ██║██║███████║   ██║   ██║  ██║██║ ╚═╝ ██║██║     ██║  ██║		#
		#	╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝  ╚═╝		#
		#################################################################################





#INSERIMENTO RISTAMPA

CREATE PROCEDURE ADDRISTAMPA
(
	IN CODICE INT,
	IN EDIZIONE INT,
	IN DATA Date,
	IN NUMERO INT

)
	BEGIN
	INSERT INTO Ristampa(codice, edizione, data, numero) VALUE (CODICE , EDIZIONE , DATA , NUMERO );
	END $

# DELETE RISTAMPA CON CODICE

CREATE PROCEDURE DELETERISTAMPA ( IN CODICE INT )
	BEGIN	
	DELETE FROM Ristampa WHERE codice = CODICE ;
	END $







		#################################################################################################
		#												#
		#	██████╗ ███████╗ ██████╗███████╗███╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗███████╗	#
		#	██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝██║██╔═══██╗████╗  ██║██╔════╝	#
		#	██████╔╝█████╗  ██║     █████╗  ██╔██╗ ██║███████╗██║██║   ██║██╔██╗ ██║█████╗  	#
		#	██╔══██╗██╔══╝  ██║     ██╔══╝  ██║╚██╗██║╚════██║██║██║   ██║██║╚██╗██║██╔══╝  	#
		#	██║  ██║███████╗╚██████╗███████╗██║ ╚████║███████║██║╚██████╔╝██║ ╚████║███████╗	#
		#	╚═╝  ╚═╝╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝	#
		#												#
		#################################################################################################





#PROCEDURA INSERIMENTO RECENSIONE

CREATE PROCEDURE ADDRECENSIONE
(
	IN PUBBLICAZIONE INT,
	IN UTENTE VARCHAR(100),
	IN TESTO VARCHAR(500)
)

	BEGIN
	INSERT INTO Recensione( pubblicazione , utente , testo ) VALUE ( PUBBLICAZIONE , UTENTE , TESTO );
	END $












#PROCEDURE STORICO


#INSERIMENTO STORICO

CREATE PROCEDURE ADDSTORICO(IN UTENTE VARCHAR(100) , DESCRIZIONE VARCHAR(100))
	BEGIN
	INSERT INTO Storico(utente,data_inserimento,descrizione ) VALUE (UTENTE,CURRENT_TIMESTAMP,DESCRIZIONE);
	END $







####################################################################################################################
#QUERY VARIE
#
#
#
####################################################################################################################
#
#
#
#			 __   __  _______  _______  __    _  _______  _______   
#			|  | |  ||       ||       ||  |  | ||       ||       |  
#			|  | |  ||_     _||    ___||   |_| ||_     _||    ___|  
#			|  |_|  |  |   |  |   |___ |       |  |   |  |   |___   
#			|       |  |   |  |    ___||  _    |  |   |  |    ___|  
#			|       |  |   |  |   |___ | | |   |  |   |  |   |___   
#			|_______|  |___|  |_______||_|  |__|  |___|  |_______|  
#
#
#QUERY LOGIN
#
#
# 
#
#
CREATE PROCEDURE LOGG( IN EMAIL1 VARCHAR(100) , IN PASSWORD1 VARCHAR(100) , OUT TIPO BOOL ) 
BEGIN
	IF EXISTS (SELECT * FROM Utente WHERE email = EMAIL1 AND password = PASSWORD1)	
	THEN 
		SET TIPO = TRUE;
	ELSE
		SET TIPO = FALSE ;
	END IF;
END $

# QUERY REGISTRAZIONE

CREATE PROCEDURE REGISTRAZIONE	(
									IN EMAIL VARCHAR(100),
									IN PASSWORD VARCHAR(100),
									IN NOME VARCHAR(100),
									IN COGNOME VARCHAR(100),
									IN CF VARCHAR(100),
									IN DATANASCITA DATE,
									IN LUOGONASCITA VARCHAR(100),
									IN NAZIONE VARCHAR(100)
								)

	BEGIN
	
		DECLARE all_ok BOOLEAN;
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET all_ok = false;
          	SET all_ok = true;
              	START TRANSACTION;
	
		CALL ADDUTENTE(EMAIL,PASSWORD);
		CALL ADDANAGRAFICA(EMAIL , NOME , COGNOME , CF , DATANASCITA , LUOGONASCITA , NAZIONE );

		IF NOT all_ok THEN ROLLBACK;
               	ELSE COMMIT;
        	END IF;

	

	END $


#QUERY RESTITUISCE IL PROFILO
CREATE PROCEDURE GETPROFILE ( IN MYEMAIL VARCHAR(100) )
	BEGIN
		SELECT * FROM Anagrafica
			WHERE email = MYEMAIL ;
	END $





CREATE PROCEDURE GETPUBBLICAZIONE(IN TITOLOPUBB VARCHAR(100)  )

	BEGIN
		SELECT * FROM Pubblicazione WHERE titolo = TITOLOPUBB ;
	END $



CREATE PROCEDURE GETEDIZIONIBYTITOLO(IN TITOLOPUBB VARCHAR(100) )
	BEGIN
		SELECT Edizione.* , Pubblicazione.data_inserimento FROM Edizione, Pubblicazione 
			WHERE Edizione.pubblicazione = Pubblicazione.id_pubblicazione 
			AND Pubblicazione.titolo = TITOLOPUBB ;
	END $

CREATE PROCEDURE GETEDIZIONEBYISBN( in id_isbn INT )
	BEGIN
		SELECT * FROM Edizione where isbn = id_isbn ;
	END $


#DATO UN ISBN ESTRARRE TUTTI I SORGENTI DISPONIBILI
CREATE PROCEDURE GETSORGENTIBYISBN ( IN IDISBN INT ) 
	BEGIN
		SELECT Sorgente.* FROM Sorgente JOIN Collegamento 
			ON Sorgente.id_sorgente = Collegamento.id_sorgente WHERE Collegamento.id_isbn = IDISBN ;
	END $


# DATA UNA PUBBLICAZIONE RESTITUIRE TUTTE GLI AUTORI(NOME,COGNOME)

CREATE PROCEDURE GETAUTORI( IN TITOLO VARCHAR(100) )
	BEGIN
	
	SELECT * FROM Autore, Scritta, Pubblicazione 
		WHERE Autore.id_autore = Scritta.id_autore 
		AND Scritta.id_pubblicazione = Pubblicazione.id_pubblicazione 
		AND Pubblicazione.titolo = TITOLO ;
	END $





CREATE PROCEDURE GETLISTAPUBBLICAZIONI()
	BEGIN
	SELECT * FROM Pubblicazione;
	END $







####################################################################################################################
#QUERY PER OPERAZIONE DA REALIZZARE
#
#
#
#



#OP 1)MODIFICA DEL LIVELLO DI UN UTENTE DA ATTIVO A PASSIVO(E VICEVERSA)

CREATE PROCEDURE UPGRADE(IN EMAIL VARCHAR(100))
	BEGIN
	UPDATE Utente SET tipo = 'ATTIVO' WHERE email = EMAIL ;	
	END $



CREATE PROCEDURE DOWNGRADE(IN EMAIL VARCHAR(100) )
	BEGIN
	UPDATE Utente SET tipo = 'PASSIVO' WHERE email = EMAIL ;
	END $


 





#OP2) ESTRAZIONE ELENCO ULTIME 10 PUBBLICAZIONI INSERITE

	CREATE PROCEDURE ULTIMEDIECI()
	BEGIN
	SELECT * FROM Pubblicazione ORDER BY  data_inserimento LIMIT 10 ;
	
	END $





#OP 4) ESTRAZIONE UTENTI + COLLABORATIVI

CREATE PROCEDURE GETCOLLABORATIVI()
	BEGIN
	SELECT  email , COUNT(id_pubblicazione) FROM Pubblicata GROUP BY email;
	END $


#OP 5) ESTRAZIONE ELENCO PUBBLICAZIONI INSERITE DA UN UTENTE

CREATE PROCEDURE GETPUBBUTENTE ( IN UTENTE VARCHAR(100) )

	BEGIN
#	SELECT *  FROM Pubblicazione WHERE id_pubblicazione =   ANY ( SELECT  id_pubblicazione FROM Pubblicata WHERE email = UTENTE );
	select * from Pubblicazione,Pubblicata where Pubblicazione.id_pubblicazione = Pubblicata.id_pubblicazione AND Pubblicata.email = UTENTE ;
	END $



										
#OP 10) approvazione o no di una recensione (da parte del moderatore).

CREATE PROCEDURE APPROVA(IN IDREC INT )
	BEGIN
	UPDATE Recensione SET stato = 'APPROVATA' WHERE id_recensione = IDREC ;
	END$


#OP 11) Inserimento di un like relativo a una pubblicazione.

CREATE PROCEDURE INSERTLIKE (IN UTENTE VARCHAR(100) , IN PUBBLICAZIONE INT) 

	BEGIN
		DECLARE all_ok BOOLEAN;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET all_ok = false;
		SET all_ok = true;
		START TRANSACTION;
		CALL ADDLIKE( UTENTE , PUBBLICAZIONE );
		CALL UPDATENUMEROLIKE(PUBBLICAZIONE) ;
		IF NOT all_ok THEN ROLLBACK;
		ELSE COMMIT;
		END IF;
 
	END $

#op 12) Calcolo numero dei like per una pubblicazione.

CREATE PROCEDURE GETNUMEROLIKE(IN TITOLOQ VARCHAR(100) )
	BEGIN
	SELECT numlike FROM Pubblicazione WHERE titolo = TITOLOQ ;
	END $


#OP 13) Estrazione elenco delle recensioni IN ATTESA per una pubblicazione

CREATE PROCEDURE GETRECENSIONIATTESA( IN TITOLOPUBB VARCHAR(100) )
	BEGIN
	SELECT Recensione.* FROM Recensione JOIN Pubblicazione ON Recensione.pubblicazione = Pubblicazione.id_pubblicazione
		WHERE Pubblicazione.titolo = 'pubb1' AND stato='IN ATTESA';
	END $



#OP 13) Estrazione elenco delle recensioni APPROVATE per una pubblicazione

CREATE PROCEDURE GETRECENSIONIAPPROVATE( IN TITOLOPUBB VARCHAR(100) )
        BEGIN
        SELECT Recensione.* FROM Recensione JOIN Pubblicazione ON Recensione.pubblicazione = Pubblicazione.id_pubblicazione
                WHERE Pubblicazione.titolo = 'pubb1' AND stato='APPROVATA';
        END $



#OP 14) Estrazione elenco delle recensioni in attesa di approvazione.(SI INTENDE PER TUTTE LE PUBBLICAZIONI)

CREATE PROCEDURE GETRECENSIONIDAGESTIRE()
	BEGIN
	SELECT * FROM Recensione WHERE stato = 'IN ATTESA';
	END $







#OP 18) Data una pubblicazione, restituire tutte le pubblicazioni del catalogo aventi gli stessi autori


CREATE PROCEDURE GETXXX( IN TITOLO VARCHAR(100) )
	BEGIN
		
	END $

#OP 18 VARiANTE) Data un autore, restituire tutte le pubblicazioni del catalogo con lo stesso autore
CREATE PROCEDURE GETPUBBLICAZIONEBYAUTORE( IN IDAUTORE INT )
	BEGIN
	select * from Pubblicazione JOIN Scritta 
		where Pubblicazione.id_pubblicazione = Scritta.id_pubblicazione AND Scritta.id_autore = IDAUTORE ;
	END $

 



CREATE PROCEDURE GETAUTOREBYID( IN IDAUTORE INT)
	BEGIN
	SELECT * FROM Autore
		WHERE id_autore = IDAUTORE ;
	END $	
#
#CHIAMATE A PROCEDURA DI ESEMPIO PER POPOLARE IL DB
#




CREATE PROCEDURE GETSORGENTEBYISBN( IN isbn INT )
	BEGIN
		SELECT Sorgente.* FROM Sorgente JOIN Collegamento ON  Collegamento.id_sorgente = Sorgente.id_sorgente
			WHERE Collegamento.id_isbn = isbn ;
 
	END $







#	   _____ ______          _____   _____ _    _ 
#	  / ____|  ____|   /\   |  __ \ / ____| |  | |
#	 | (___ | |__     /  \  | |__) | |    | |__| |
#	  \___ \|  __|   / /\ \ |  _  /| |    |  __  |
#	  ____) | |____ / ____ \| | \ \| |____| |  | |
#	 |_____/|______/_/    \_\_|  \_\\_____|_|  |_|
#	                                              

# RICERCA PER ISDN
CREATE PROCEDURE SEARCHBYISBN ( IN CODICEISBN INT )
	BEGIN
		SELECT * FROM Pubblicazione join Edizione ON Pubblicazione.id_pubblicazione = Edizione.pubblicazione 
			WHERE  Edizione.isbn = CODICEISBN ;
	END $













DELIMITER ;







#INSERIMENTO UTENTI

CALL ADDUTENTE('tommasodisalle@gmail.com','password');
CALL ADDUTENTE('pippo@gmail.com','password');
CALL ADDUTENTE('topolino@gmail.com','password');
CALL ADDUTENTE('pluto@gmail.com','password');

#INSERIMENTO ANAGRAFICA

CALL ADDANAGRAFICA('tommasodisalle@gmail.com','tommaso','Di Salle','dsltms86e11g878o','1986-11-05','raiano','italia');
CALL ADDANAGRAFICA('pippo@gmail.com','pippo','cognomepippo','cfpippo','2000-01-01','topolonia','fantasia');
CALL ADDANAGRAFICA('topolino@gmail.com','topolino','cognometopolino','cftopolino','1950-02-02','topolonia','fantasia');
CALL ADDANAGRAFICA('pluto@gmail.com','pluto','cogmonepluto','cfpluto','1960-03-03','topolonia','fantasia');



#INSERIMENTO PUBBLICAZIONI

CALL ADDPUBBLICAZIONE('pubb1','einaudi');
CALL ADDPUBBLICAZIONE('pubb2','maggioli');
CALL ADDPUBBLICAZIONE('pubb3','einaudi');
CALL ADDPUBBLICAZIONE('pubb4','maggioli');
CALL ADDPUBBLICAZIONE('pubb5','einaudi');
CALL ADDPUBBLICAZIONE('pubb6','maggioli');
CALL ADDPUBBLICAZIONE('pubb7','einaudi');
CALL ADDPUBBLICAZIONE('pubb8','maggioli');
CALL ADDPUBBLICAZIONE('pubb9','einaudi');
CALL ADDPUBBLICAZIONE('pubb10','maggioli');
CALL ADDPUBBLICAZIONE('pubb11','einaudi');
CALL ADDPUBBLICAZIONE('pubb12','maggioli');
CALL ADDPUBBLICAZIONE('pubb13','einaudi');
CALL ADDPUBBLICAZIONE('pubb14','maggioli');
CALL ADDPUBBLICAZIONE('pubb15','einaudi');
CALL ADDPUBBLICAZIONE('pubb16','maggioli');
CALL ADDPUBBLICAZIONE('pubb17','einaudi');
CALL ADDPUBBLICAZIONE('pubb18','maggioli');
CALL ADDPUBBLICAZIONE('pubb19','einaudi');
CALL ADDPUBBLICAZIONE('pubb20','maggioli');
CALL ADDPUBBLICAZIONE('pubb21','einaudi');
CALL ADDPUBBLICAZIONE('pubb22','maggioli');


CALL ADDPUBBLICATA( 1  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 2  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 3  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 4  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 5  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 6  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 7  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 8  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 9  , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 10 , 'tommasodisalle@gmail.com');
CALL ADDPUBBLICATA( 11 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 12 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 13 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 14 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 15 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 16 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 17 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 18 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 19 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 20 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 21 , 'pippo@gmail.com');
CALL ADDPUBBLICATA( 22 , 'pippo@gmail.com');


CALL ADDAUTORE('aaa','zzz');
CALL ADDAUTORE('bbb','xxx');
CALL ADDAUTORE('ccc','yyy');
CALL ADDAUTORE('ddd','hhh');
CALL ADDAUTORE('eee','vvv');
CALL ADDAUTORE('fff','qqq');
CALL ADDAUTORE('ggg','aba');
CALL ADDAUTORE('qwe','zxc');
CALL ADDAUTORE('iii','fgh');
CALL ADDAUTORE('lll','yui');
CALL ADDAUTORE('mmm','tre');
CALL ADDAUTORE('nnn','gfd');
CALL ADDAUTORE('ooo','ghj');



CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 1 ,1 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 1 ,2 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 1 ,3 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 1 ,4 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 2 ,1 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 3 ,1 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 4 ,5 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 5 ,6 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 6 ,7 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 7 ,8 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 8 ,9 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 9 ,10 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 10 ,11 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 11 ,12 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 12 ,13 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 13 ,13 );
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 13 ,1);
CALL ADDPUBBLICAZIONESCRITTADAAUTORE ( 13 ,5);




CALL ADDRECENSIONE(1,'tommasodisalle@gmail.com','ben fatto');
CALL ADDRECENSIONE(1,'pippo@gmail.com','ben fatto');
CALL ADDRECENSIONE(1,'pluto@gmail.com','ben fatto');
CALL ADDRECENSIONE(1,'topolino@gmail.com','ben fatto');
CALL ADDRECENSIONE(2,'pippo@gmail.com','ben fatto');
CALL ADDRECENSIONE(2,'tommasodisalle@gmail.com','ben fatto');
CALL ADDRECENSIONE(2,'topolino@gmail.com','ben fatto');
CALL ADDRECENSIONE(2,'pluto@gmail.com','ben fatto');


CALL ADDEDIZIONE(999,1,87,'ITALIANA','database informatica','2000-02-02');
CALL ADDEDIZIONE(888,1,87,'ITALIANA','database informatica','2000-02-02');
CALL ADDEDIZIONE(111,2,87,'ITALIANA','database informatica','2001-02-02');
CALL ADDEDIZIONE(222,3,87,'ITALIANA','database informatica','2002-02-02');
CALL ADDEDIZIONE(333,4,87,'ITALIANA','database informatica','2003-02-02');
CALL ADDEDIZIONE(444,5,87,'ITALIANA','database informatica','2004-02-02');
CALL ADDEDIZIONE(555,6,87,'ITALIANA','database informatica','2002-02-02');


#INSERT INTO Sorgente(tipo, uri,formato,descrizione) VALUE ( TIPO , URI , FORMATO , DESCRIZIONE );
#TIPO = IMMAGINE ,DOWNLOAD , ACQUISTO
# tipo=”download”, URI=”http://server.net/book.pdf”, formato=”application/pdf”,descrizione=”versione elettronica gratuita”
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente1.pdf','application/pdf','preview');
CALL ADDSORGENTE('ACQUISTO','www.amazon.it/aaa','application/pdf','acquista online');
CALL ADDSORGENTE('ACQUISTO','www.amazon.it/bbb','application/pdf','acquista online');
CALL ADDSORGENTE('ACQUISTO','www.amazon.it/ccc','application/pdf','acquista online');
CALL ADDSORGENTE('ACQUISTO','www.amazon.it/ddd','application/pdf','acquista online');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente2.pdf','application/pdf','preview');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente3.pdf','application/pdf','preview');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente4.pdf','application/pdf','preview');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente5.pdf','application/pdf','versione elettronica gratuita');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente6.pdf','application/pdf','versione elettronica gratuita');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente7.pdf','application/pdf','versione elettronica gratuita');
CALL ADDSORGENTE('DOWNLOAD','/BIBLOTECA/sorgente8.pdf','application/pdf','versione elettronica gratuita');
CALL ADDSORGENTE('IMMAGINE','/BIBLOTECA/image1.jpg','image/jpg','copertina1');
CALL ADDSORGENTE('IMMAGINE','/BIBLOTECA/image2.jpg','image/jpg','copertina2');
CALL ADDSORGENTE('IMMAGINE','/BIBLOTECA/image3.jpg','image/jpg','copertina3');



CALL ADDCOLLEGAMENTO(1,111);
CALL ADDCOLLEGAMENTO(2,222);
CALL ADDCOLLEGAMENTO(3,333);
CALL ADDCOLLEGAMENTO(4,444);
CALL ADDCOLLEGAMENTO(5,555);
CALL ADDCOLLEGAMENTO(6,999);
CALL ADDCOLLEGAMENTO(7,111);
CALL ADDCOLLEGAMENTO(8,222);
CALL ADDCOLLEGAMENTO(9,222);
CALL ADDCOLLEGAMENTO(10,333);
CALL ADDCOLLEGAMENTO(11,333);
CALL ADDCOLLEGAMENTO(12,555);
CALL ADDCOLLEGAMENTO(13,111);
CALL ADDCOLLEGAMENTO(14,222);
CALL ADDCOLLEGAMENTO(15,888);





