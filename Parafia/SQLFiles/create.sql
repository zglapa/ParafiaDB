CREATE  TABLE "public".initializationsacramentstypes ( 
	id                   serial  NOT NULL ,
	sacramenttype        varchar(100)  NOT NULL unique ,
	CONSTRAINT pk_initializationsacramentstypes_id PRIMARY KEY ( id )
 );


CREATE  TABLE "public".intentions ( 
	id                   serial  NOT NULL ,
	intention            varchar(100)  NOT NULL unique ,
	CONSTRAINT pk_intentions_id_0 PRIMARY KEY ( id )
 );

CREATE  TABLE "public".laybrothers ( 
	id                   serial NOT NULL ,
	forename             varchar(100)  NOT NULL ,
	surname              varchar(100)  NOT NULL ,
	gender               char(1)  NOT NULL ,
	isparishioner        bool  NOT NULL ,
	dateofbirth          date  NOT NULL ,
	motherid             int,
	fatherid             int,
	godfatherid	     int,
	godmotherid          int,
	CONSTRAINT pk_parishioners_id UNIQUE ( id ) ,
	CONSTRAINT pk_laybrothers_id PRIMARY KEY ( id ),
	CHECK(gender='F' OR gender='M'),
	CHECK(dateofbirth<=current_date),
	CHECK (NOT(motherid=fatherid)),
	CHECK (NOT(motherid=godmotherid)),
	CHECK (NOT(fatherid=godfatherid)),
	CHECK (NOT(godmotherid=godfatherid)),
	CHECK (NOT(id=motherid or id=godmotherid or id=godfatherid or id=godmotherid))
 );
CREATE  TABLE "public".masstypes ( 
	id                   serial  NOT NULL ,
	"type"               varchar(20)  NOT NULL unique ,
	CONSTRAINT pk_masstypes_id UNIQUE ( id ) ,
	CONSTRAINT pk_masstypes_id_0 PRIMARY KEY ( id )
 );

CREATE  TABLE "public".meetingtypes ( 
	id                   serial  NOT NULL ,
	meetingtype          varchar(100)  NOT NULL unique ,
	CONSTRAINT pk_meetingtypes_id_0 PRIMARY KEY ( id )
 );


CREATE  TABLE "public".priests ( 
    laybrotherid         int  NOT NULL references laybrothers(id),
	servicestart          date  NOT NULL ,
	serviceend           date,
	CHECK(servicestart<serviceend)
 );


CREATE  TABLE "public".acolytemeetings ( 
	id                   serial  NOT NULL ,
	meetingdate          date  NOT NULL ,
	meetingtype          int  NOT NULL ,
	meetingcost          numeric(9,2)   ,
	CONSTRAINT pk_acolytemeetings_id_0 PRIMARY KEY ( id ),
	CHECK(meetingdate<=current_date)
 );


CREATE  TABLE "public".acolytes ( 
	laybrotherid         int  NOT NULL,
	inaugurationdate     date NOT NULL,
	enddate		     date,
	CHECK ( enddate > inaugurationdate )

 );


CREATE  TABLE "public".acolytesonmeetings ( 
	acolyteid            int  NOT NULL ,
	meetingid            int  NOT NULL ,
	CONSTRAINT acolytesonmeetings_unique UNIQUE (acolyteid,meetingid)
 );

CREATE  TABLE "public".apostates ( 
	id                   serial  NOT NULL ,
	laybrotherid         int  NOT NULL ,
	apostasydate         date  NOT NULL ,
	valid 				 bool NOT NULL 	,
	CONSTRAINT pk_apostates_id PRIMARY KEY ( id ),
	CHECK(apostasydate<=current_date)
 );


CREATE  TABLE "public".excommunicated ( 
	laybrotherid         int  NOT NULL unique ,
	excommuniondate         date  NOT NULL ,
	CONSTRAINT pk_excommunicated_id PRIMARY KEY ( laybrotherid ),
	CHECK(excommuniondate<=current_date)
);


CREATE  TABLE "public".donations ( 
	id                   serial  NOT NULL ,
	amount               numeric(11,2)  NOT NULL ,
	donationdate         date  NOT NULL ,
	laybrotherid         int  NOT NULL ,
	CONSTRAINT pk_donations_id PRIMARY KEY ( id ),
	CHECK(donationdate<=current_date),
	CHECK(amount>0)
 );

CREATE  TABLE "public".masses ( 
	massid               serial  NOT NULL ,
	massdate             date  NOT NULL ,
	intentionid          int  NOT NULL ,
	offering             numeric(9,2)   ,
	masstype             int  NOT NULL ,
	leadingpriestid      int  NOT NULL ,
	CONSTRAINT pk_masses_massid_0 PRIMARY KEY ( massid ),
	CHECK(massdate<=current_date),
	CHECK(offering>0)
 );


CREATE  TABLE "public".priestsmasses ( 
	priestid             int  NOT NULL ,
	massid               int  NOT NULL ,
    CONSTRAINT priestsmasses_unq UNIQUE (priestid,massid)
 );

CREATE  TABLE "public".deaths ( 
	massid               int ,
	laybrotherid         int  NOT NULL ,
	deathdate            date  NOT NULL ,
	CONSTRAINT u_deaths_laybrotherid UNIQUE ( laybrotherid ),
	CHECK(deathdate<=current_date)
 );

CREATE  TABLE "public".initializationsacraments ( 
	id                   serial  NOT NULL ,
	massid               int  NOT NULL ,
	laybrotherid         int  NOT NULL ,
	sacramenttype        int  NOT NULL ,
	CONSTRAINT pk_initializationsacraments_id_0 PRIMARY KEY ( id ),
	CONSTRAINT u_laybrotherid_sacramenttype UNIQUE (laybrotherid, sacramenttype)
 );


CREATE  TABLE "public".marriages ( 
	id                   serial  NOT NULL ,
	wifeid               int  NOT NULL ,
	husbandid            int  NOT NULL ,
	massid               int  NOT NULL ,
	wifebestpersonid     int,
	husbandbestpersonid  int,
	CONSTRAINT pk_marriages_id_0 PRIMARY KEY ( id ),
	CHECK (NOT(wifeid=husbandid)),
	CHECK (NOT(wifeid=wifebestpersonid)),
	CHECK (NOT(wifebestpersonid=husbandid)),
	CHECK (NOT(wifebestpersonid=husbandbestpersonid)),
	CHECK (NOT(husbandbestpersonid=husbandid)),
	CHECK (NOT(husbandbestpersonid=wifeid))
 );


CREATE  TABLE "public".acolytesmasses ( 
	acolyteid         int  NOT NULL ,
	massid            int  NOT NULL ,
    CONSTRAINT acolytesmasses_unq UNIQUE (acolyteid,massid)
 );

ALTER TABLE "public".acolytemeetings ADD CONSTRAINT fk_acolytemeetings_meetingtypes FOREIGN KEY ( meetingtype ) REFERENCES "public".meetingtypes( id );

ALTER TABLE "public".acolytes ADD CONSTRAINT fk_acolytes_parishioners FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".acolytesonmeetings ADD CONSTRAINT fk_acolytesonmeetings_acolytemeetings FOREIGN KEY ( meetingid ) REFERENCES "public".acolytemeetings( id );

ALTER TABLE "public".acolytesonmeetings ADD CONSTRAINT fk_acolytesonmeetings_acolytes FOREIGN KEY ( acolyteid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".apostates ADD CONSTRAINT fk_apostates_laybrothers FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".excommunicated ADD CONSTRAINT fk_excommunicated_laybrothers FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".deaths ADD CONSTRAINT fk_deaths_masses FOREIGN KEY ( massid ) REFERENCES "public".masses( massid );

ALTER TABLE "public".deaths ADD CONSTRAINT fk_deaths_parishioners FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".donations ADD CONSTRAINT fk_donations_parishioners FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".initializationsacraments ADD CONSTRAINT fk_initializationsacraments_initializationsacramentstypes FOREIGN KEY ( sacramenttype ) REFERENCES "public".initializationsacramentstypes( id );

ALTER TABLE "public".initializationsacraments ADD CONSTRAINT fk_initializationsacraments_masses FOREIGN KEY ( massid ) REFERENCES "public".masses( massid );

ALTER TABLE "public".initializationsacraments ADD CONSTRAINT fk_initializationsacraments_parishioners FOREIGN KEY ( laybrotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".laybrothers ADD CONSTRAINT fk_laybrothers_laybrothers FOREIGN KEY ( fatherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".laybrothers ADD CONSTRAINT fk_laybrothers_laybrothers_0 FOREIGN KEY ( motherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".laybrothers ADD CONSTRAINT fk_laybrothers_laybrothers_1 FOREIGN KEY ( godfatherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".laybrothers ADD CONSTRAINT fk_laybrothers_laybrothers_2 FOREIGN KEY ( godmotherid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".marriages ADD CONSTRAINT fk_marriages_masses FOREIGN KEY ( massid ) REFERENCES "public".masses( massid );

ALTER TABLE "public".marriages ADD CONSTRAINT fk_marriages_parishioners FOREIGN KEY ( wifeid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".marriages ADD CONSTRAINT fk_marriages_parishioners_0 FOREIGN KEY ( husbandid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".marriages ADD CONSTRAINT fk_marriages_parishioners_1 FOREIGN KEY ( wifebestpersonid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".marriages ADD CONSTRAINT fk_marriages_parishioners_2 FOREIGN KEY ( husbandbestpersonid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".acolytesmasses ADD CONSTRAINT fk_acolytesmasses_acolytes FOREIGN KEY ( acolyteid ) REFERENCES "public".laybrothers(id);

ALTER TABLE "public".acolytesmasses ADD CONSTRAINT fk_acolytesmasses_masses FOREIGN KEY ( massid ) REFERENCES "public".masses( massid );

ALTER TABLE "public".masses ADD CONSTRAINT fk_masses_intentions FOREIGN KEY ( intentionid ) REFERENCES "public".intentions( id );

ALTER TABLE "public".masses ADD CONSTRAINT fk_masses_masstypes FOREIGN KEY ( masstype ) REFERENCES "public".masstypes( id );

ALTER TABLE "public".masses ADD CONSTRAINT fk_masses_leadingpriestid FOREIGN KEY ( leadingpriestid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".priestsmasses ADD CONSTRAINT fk_priestsmasses_priests FOREIGN KEY ( priestid ) REFERENCES "public".laybrothers( id );

ALTER TABLE "public".priestsmasses ADD CONSTRAINT fk_priestsmasses_masses FOREIGN KEY ( massid ) REFERENCES "public".masses( massid );




CREATE VIEW importantdates AS (
 SELECT
  laybrothers.id AS "laybrotherid",
  dateofbirth,
  MAX(CASE WHEN sacramenttype = 1 THEN massdate ELSE NULL END) AS "baptism",
  MAX(CASE WHEN sacramenttype = 2 THEN massdate ELSE NULL END) AS "eucharistic",
  MAX(CASE WHEN sacramenttype = 3 THEN massdate ELSE NULL END) AS "confirmation",
  deathdate
 FROM
  laybrothers LEFT JOIN initializationsacraments ON (laybrothers.id = initializationsacraments.laybrotherid)
  LEFT JOIN masses ON (initializationsacraments.massid = masses.massid)
  LEFT JOIN deaths ON (deaths.laybrotherid = laybrothers.id)
 GROUP BY 1, 6
 ORDER BY 1
);


--returns null if all is right, otherwise ID
CREATE OR REPLACE FUNCTION checksacramentsintegrity() RETURNS INT AS
$checksacramentsintegrity$
DECLARE
 row RECORD;
 date1 DATE;
 date2 DATE;
 date3 DATE;
 date4 DATE;
 date5 DATE;
BEGIN
 FOR row IN (SELECT * FROM importantdates) --check if the dates are ordered properly
 LOOP
  date1 = row.dateofbirth;
  IF (row.Baptism IS NULL)
  THEN
   date2 = date1;
  ELSE
   date2 = row.Baptism;
  END IF;

  IF (row.Eucharistic IS NULL)
  THEN
   date3 = date2;
  ELSE
   date3 = row.Eucharistic;
   IF (date3 < (date1+INTERVAL'3 years')::date)
   THEN
    RETURN row.id;
   END IF;
  END IF;

  IF (row.Confirmation IS NULL)
  THEN
   date4 = date3;
  ELSE
   date4 = row.Confirmation;
  END IF;

  IF (row.deathdate IS NULL)
  THEN
   date5 = date4;
  ELSE
   date5 = row.deathdate;
  END IF;

  IF (NOT(date1 <= date2 AND date2 <= date3 AND date3 <= date4 AND date4 <= date5))
  THEN
   RETURN row.laybrotherid;
  END IF;
 END LOOP;
 RETURN NULL;
END;
$checksacramentsintegrity$
language plpgsql;


--check if laybrother was born when he donated
CREATE OR REPLACE FUNCTION donorbirthdate() RETURNS TRIGGER AS
$donorbirthdate$
DECLARE
 death date;
BEGIN
 IF ((SELECT dateofbirth FROM laybrothers WHERE laybrothers.id = NEW.laybrotherid) >= NEW.donationdate)
 THEN
  RETURN NULL;
 END IF;
 death = (SELECT deathdate from deaths where deaths.laybrotherid=new.laybrotherid);
 if(death is not null and death < new.donationdate)
 then return null;
 end if;
 RETURN NEW;
END;
$donorbirthdate$
language plpgsql;

CREATE TRIGGER checkdonorbirthdate BEFORE INSERT OR UPDATE ON donations
FOR EACH ROW EXECUTE PROCEDURE donorbirthdate();

--marriages_check
create or replace function marriages_check() returns trigger as
    $$
    declare
    massDate date;
	best1Date date;
	best2Date date;
    begin
	IF ((SELECT COUNT(*) FROM priests WHERE laybrotherid = NEW.husbandid)>0)
	THEN
	 RETURN NULL;
	END IF;
        massDate = (select m.massdate from masses m where m.massid=new.massid);
        if((select l.dateofbirth from laybrothers l where l.id=new.wifeid) + INTERVAL '10 years')::date > massDate then return null;end if;
        if((select l.dateofbirth from laybrothers l where l.id=new.husbandid) + INTERVAL '10 years')::date > massDate then return null;end if;
	if new.wifebestpersonid is not null then
        	if((select l.dateofbirth from laybrothers l where l.id=new.wifebestpersonid) + INTERVAL '10 years')::date > massDate then return null;end if;
		best1Date = (select deathdate from deaths where laybrotherid=new.wifebestpersonid)::date;
		if (best1Date is not null and best1Date<massDate) then return null; end if;
	end if;
	if new.husbandbestpersonid is not null then
        	if((select l.dateofbirth from laybrothers l where l.id=new.husbandbestpersonid) + INTERVAL '10 years')::date > massDate then return null;end if;
		best2Date = (select deathdate from deaths where laybrotherid=new.husbandbestpersonid)::date;
                if (best2Date is not null and best2Date<massDate) then return null; end if;
	end if;
	if  (select l.gender from laybrothers l where l.id=new.wifeid) = 'M' then return null;end if;
	if  (select l.gender from laybrothers l where l.id=new.husbandid) = 'F' then return null;end if;
        return new;
    end;
$$language plpgsql;

create trigger marriages_check before insert or update on marriages
    for each row execute procedure marriages_check();

--laybrothers_check
create or replace function laybrother_check() returns trigger as
    $$
    begin
        if( (select l.dateofbirth from laybrothers l where l.id=new.motherid)+ INTERVAL '10 years')::date > new.dateofbirth and new.motherid is not null then return null;end if;
        if( (select  l.dateofbirth from laybrothers l where l.id=new.fatherid) + INTERVAL '10 years')::date > new.dateofbirth and new.fatherid is not null then return null;end if;
        if( (select  l.dateofbirth from laybrothers l where l.id=new.godmotherid) + INTERVAL '10 years')::date > new.dateofbirth and new.godmotherid is not null then return null;end if;
        if( (select  l.dateofbirth from laybrothers l where l.id=new.godfatherid) + INTERVAL '10 years')::date > new.dateofbirth and new.godfatherid is not null then return null;end if;
        if  (select l.gender from laybrothers l where l.id=new.motherid) = 'M' and new.motherid is not null then return null;end if;
	    if  (select l.gender from laybrothers l where l.id=new.fatherid) = 'F' and new.fatherid is not null then return null;end if;
	    if  (select l.gender from laybrothers l where l.id=new.godmotherid) = 'M' and new.godmotherid is not null then return null;end if;
        if  (select l.gender from laybrothers l where l.id=new.godfatherid) = 'F' and new.godfatherid is not null then return null;end if;
	    if  (new.godfatherid = new.id or new.godmotherid = new.id) then return null; end if;
        if(new.godfatherid is not null and isAGoodGodParent(new.id,new.godfatherid,new.dateofbirth) = false) then
            return null;
        end if;
        if(new.godmotherid is not null and isAGoodGodParent(new.id,new.godmotherid,new.dateofbirth) = false) then
            return null;
        end if;
	return new;
    end;
    $$language plpgsql;
create trigger laybrother_check before insert on laybrothers
    for each row execute procedure laybrother_check();

create or replace function isAGoodGodParent(childid int, godparentid int, childBD date) returns bool as
    $$
    declare
        godparentdeath date;
        godparentapostasy date;
        godparentexcom date;
        baptism date;
    begin
        godparentdeath=(select deathdate from deaths where godparentid=laybrotherid);
        godparentapostasy=(select apostasydate from apostates where godparentid=laybrotherid and valid='t');
        godparentexcom=(select excommuniondate from excommunicated where godparentid=laybrotherid);
        baptism=(select massdate from initializationsacraments i join masses m on i.massid = m.massid where i.laybrotherid=childid and i.sacramenttype=1);
        if(baptism is not null) then
            if(godparentdeath is not null and godparentdeath < baptism) then
                return false;
            end if;
            if(godparentapostasy is not null and godparentapostasy < baptism) then
                return false;
            end if;
            if(godparentexcom is not null and godparentexcom < baptism) then
                return false;
            end if;
        else
            if(godparentdeath is not null and godparentdeath < childBD) then
                return false;
            end if;
            if(godparentapostasy is not null and godparentapostasy < childBD) then
                return false;
            end if;
            if(godparentexcom is not null and godparentexcom < childBD) then
                return false;
            end if;
        end if;
        return true;
    end;
    $$ language plpgsql;


create or replace function laybrothers_updt() returns trigger as
    $$
    declare
        sex char;
    begin
        new.id=old.id;
        new.motherid=old.motherid;
        new.fatherid=old.fatherid;
        new.dateofbirth=old.dateofbirth;
        if(old.godfatherid is not null or isAGoodGodParent(new.id,new.godfatherid,new.dateofbirth) = false or new.godfatherid=null) then
            new.godfatherid=old.godfatherid;
        else
            sex=(select gender from laybrothers where id=new.godfatherid);
            if(sex='F')then return null;
            end if;
        end if;
        if(old.godmotherid is not null or isAGoodGodParent(new.id,new.godmotherid,new.dateofbirth) = false or new.godfatherid=null) then
            new.godmotherid=old.godmotherid;
        else
            sex=(select gender from laybrothers where id=new.godfatherid);
            if(sex='M')then return null;
            end if;
        end if;
	return new;
    end;
    $$language plpgsql;
create trigger laybrothers_update before update on laybrothers
    for each row execute procedure laybrothers_updt();
--check if laybrother can apostate
CREATE OR REPLACE FUNCTION apostasydate() RETURNS TRIGGER AS
$apostasydate$
BEGIN
 If ((SELECT COUNT(*) FROM excommunicated WHERE laybrotherid = NEW.laybrotherid) > 0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT COUNT(*) FROM apostates WHERE laybrotherid = NEW.laybrotherid AND valid = true) > 0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT COUNT(*) FROM deaths WHERE laybrotherid = NEW.laybrotherid) > 0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT MAX(dateofbirth) FROM laybrothers WHERE laybrothers.id = NEW.laybrotherid) >= NEW.apostasydate)
 THEN
  RETURN NULL;
 END IF;
 UPDATE acolytes SET enddate = NEW.apostasydate WHERE laybrotherid = NEW.laybrotherid AND enddate IS NULL;
 UPDATE priests SET serviceend = NEW.apostasydate WHERE laybrotherid = NEW.laybrotherid AND serviceend IS NULL;
 NEW.valid = true;
 RETURN NEW;
END;
$apostasydate$
language plpgsql;

CREATE TRIGGER checkapostasydate BEFORE INSERT ON apostates
FOR EACH ROW EXECUTE PROCEDURE apostasydate();

--apostate update
CREATE OR REPLACE FUNCTION apostatyupdate() RETURNS TRIGGER AS
$apostatyupdate$
BEGIN
 NEW.id = OLD.id;
 NEW.laybrotherid = OLD.laybrotherid;
 NEW.apostasydate = OLD.apostasydate;
 IF (NEW.valid = true)
 THEN
  RETURN NULL;
 END IF;

 UPDATE acolytes SET enddate = NEW.apostasydate WHERE laybrotherid = NEW.laybrotherid AND enddate IS NULL;
 UPDATE priests SET serviceend = NEW.apostasydate WHERE laybrotherid = NEW.laybrotherid AND serviceend IS NULL;
 RETURN NEW;
END;
$apostatyupdate$
language plpgsql;

CREATE TRIGGER apostatyupdt BEFORE UPDATE ON apostates
FOR EACH ROW EXECUTE PROCEDURE apostatyupdate();

--excommunicated
CREATE OR REPLACE FUNCTION excommunicatedinsert() RETURNS TRIGGER AS
$excommunicatedinsert$
BEGIN
 IF ((SELECT COUNT(*) FROM deaths WHERE laybrotherid = NEW.laybrotherid) > 0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT MAX(dateofbirth) FROM laybrothers WHERE laybrothers.id = NEW.laybrotherid) >= NEW.excommuniondate)
 THEN
  RETURN NULL;
 END IF;

 UPDATE acolytes SET enddate = NEW.excommuniondate WHERE laybrotherid = NEW.laybrotherid AND enddate IS NULL;
 UPDATE priests SET serviceend = NEW.excommuniondate WHERE laybrotherid = NEW.laybrotherid AND serviceend IS NULL;
 RETURN NEW;
END;
$excommunicatedinsert$
language plpgsql;

CREATE TRIGGER excommunicatedins BEFORE INSERT ON excommunicated
FOR EACH ROW EXECUTE PROCEDURE excommunicatedinsert();


--check if someone is alive before you kill him
create or replace function deaths_check() returns trigger as
    $$
    declare
        a int;
    begin
        a = checksacramentsintegrity();
        if(a is not null) then delete from deaths where laybrotherid=a; return null;
        end if;
	IF ((NEW.massid is not null) and ((SELECT massdate FROM masses WHERE massid = NEW.massid) < NEW.deathdate))
	THEN
	 DELETE FROM deaths WHERE laybrotherid = NEW.laybrotherid;
	 RETURN NULL;
	END IF;

	UPDATE acolytes SET enddate = NEW.deathdate WHERE laybrotherid = NEW.laybrotherid AND enddate IS NULL;
	UPDATE priests SET serviceend = NEW.deathdate WHERE laybrotherid = NEW.laybrotherid AND serviceend IS NULL;
	return null;

    end;
    $$language plpgsql;
create trigger deaths_check after insert or update on deaths
    for each row execute procedure deaths_check();

----ALL PRIEST TRIGGERS
--priest insert check, in our parish person cannot become priest if previously married
CREATE OR REPLACE FUNCTION checkpriests() RETURNS TRIGGER AS
$checkpriests$
BEGIN
 IF (((SELECT dateofbirth FROM laybrothers WHERE id = NEW.laybrotherid)+INTERVAL'20 years')::date > NEW.servicestart)
 THEN
  RETURN NULL;
 END IF;
 IF (((SELECT deathdate FROM deaths WHERE laybrotherid = NEW.laybrotherid) < NEW.serviceend))
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT COUNT(*) FROM priests WHERE servicestart < NEW.servicestart AND serviceend > NEW.serviceend AND laybrotherid = NEW.laybrotherid) >0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT gender FROM laybrothers WHERE id = NEW.laybrotherid) = 'F')
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT COUNT(*) from marriages WHERE husbandid = NEW.laybrotherid) > 0)
 THEN
  RETURN NULL;
 END IF;
 UPDATE acolytes SET enddate = NEW.servicestart WHERE laybrotherid = NEW.laybrotherid AND enddate IS NULL;
 RETURN NEW;
END;
$checkpriests$
language plpgsql;

CREATE TRIGGER prisetcheck BEFORE INSERT ON priests
FOR EACH ROW EXECUTE PROCEDURE checkpriests();

--priest update check
CREATE OR REPLACE FUNCTION priestsupdate() RETURNS TRIGGER AS
$priestupdate$
BEGIN
 NEW.servicestart = OLD.servicestart;
 NEW.laybrotherid = OLD.laybrotherid;
 IF (NEW.servicestart > NEW.serviceend)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT deathdate FROM deaths WHERE deaths.laybrotherid = NEW.laybrotherid) < NEW.serviceend)
 THEN
  RETURN NULL;
 END IF;
 RETURN NEW;
END;
$priestupdate$
language plpgsql;

CREATE TRIGGER priestupdatecheck BEFORE UPDATE ON priests
FOR EACH ROW EXECUTE PROCEDURE priestsupdate();


--mass check, if leading priest was active
CREATE OR REPLACE FUNCTION checkmasses() RETURNS TRIGGER AS
$checkmasses$
BEGIN
 IF ((SELECT COUNT(*) FROM priests WHERE laybrotherid = NEW.leadingpriestid AND servicestart <= NEW.massdate AND (( serviceend is null ) or (serviceend >=NEW.massdate))) = 0)
 THEN
  RETURN NULL;
 END IF; 
 RETURN NEW;
END;
$checkmasses$
language plpgsql;

CREATE TRIGGER masscheck BEFORE INSERT OR UPDATE ON masses
FOR EACH ROW EXECUTE PROCEDURE checkmasses();

--same as above, but for priestsmasses
CREATE OR REPLACE FUNCTION checkpriestmasses() RETURNS TRIGGER AS
$checkpriestmasses$
DECLARE
 mass DATE;
BEGIN
 mass = (SELECT massdate FROM masses WHERE masses.massid = NEW.massid); 
 IF ((SELECT COUNT(*) FROM priests WHERE laybrotherid = NEW.priestid AND servicestart >= mass AND serviceend <=mass) != 0)
 THEN
  RETURN NULL;
 END IF;
 IF ((SELECT COUNT(*) FROM masses WHERE leadingpriestid = NEW.priestid AND massid = NEW.massid) > 0)
 THEN
  RETURN NULL;
 END IF;
 RETURN NEW;
END;
$checkpriestmasses$
language plpgsql;

CREATE TRIGGER priestmassescheck BEFORE INSERT OR UPDATE ON priestsmasses
FOR EACH ROW EXECUTE PROCEDURE checkpriestmasses();
----END OF PRIEST TRIGGERS


--check intialization sacraments
CREATE OR REPLACE FUNCTION checkinisacins() RETURNS TRIGGER AS
$checkinisacins$
DECLARE
 theid INT;
 mass DATE;
BEGIN
 IF ((SELECT COUNT(*) FROM priests WHERE priests.laybrotherid = NEW.laybrotherid) >0)
 THEN
  DELETE FROM initializationsacraments WHERE id = NEW.id;
  RETURN NULL;
 END IF;

 mass = (SELECT massdate FROM masses WHERE massid = NEW.massid);
 IF ((SELECT COUNT(*) FROM apostates WHERE apostates.laybrotherid = NEW.laybrotherid AND valid = true AND apostates.apostasydate < mass) > 0)
 THEN
  DELETE FROM initializationsacraments WHERE id = NEW.id;
  RETURN NULL;
 END IF;

 IF ((SELECT COUNT(*) FROM excommunicated WHERE excommunicated.laybrotherid = NEW.laybrotherid ) > 0)
 THEN
  DELETE FROM initializationsacraments WHERE id = NEW.id;
  RETURN NULL;
 END IF;

 theid = checksacramentsintegrity();
 IF (theid IS NOT NULL)
 THEN
  DELETE FROM initializationsacraments WHERE laybrotherid = theid; --initializationsacraments.id = theid;
  RETURN NULL;
 END IF;
 RETURN NULL;
END;
$checkinisacins$
language plpgsql;

CREATE TRIGGER ckechinitializationsacraments AFTER INSERT ON initializationsacraments
FOR EACH ROW EXECUTE PROCEDURE checkinisacins();

CREATE RULE inisacupd AS ON UPDATE TO initializationsacraments DO INSTEAD NOTHING;

--check acolytes on meetings
CREATE OR REPLACE FUNCTION checkacoonmeetings() RETURNS TRIGGER AS
$checkacoonmeetings$
DECLARE
 meeting DATE;
BEGIN
 meeting = (SELECT meetingdate FROM acolytemeetings WHERE id = NEW.meetingid);
 if (select count(laybrotherid) from acolytes where laybrotherid=new.acolyteid and meeting>inaugurationdate and (enddate is null or enddate>meeting)) <= 0
 then
     return null;
     end if;
 RETURN NEW;
END;
$checkacoonmeetings$
language plpgsql;

CREATE TRIGGER checkacolytesonmeetings BEFORE INSERT ON acolytesonmeetings
FOR EACH ROW EXECUTE PROCEDURE checkacoonmeetings();

--check acolytes on masses
CREATE OR REPLACE FUNCTION checkacoonmasses() RETURNS TRIGGER AS
$checkacoonmasses$
DECLARE
 mass DATE;
BEGIN
 mass = (SELECT massdate FROM masses WHERE massid = NEW.massid);
 if (select count(laybrotherid) from acolytes where laybrotherid=new.acolyteid and mass>inaugurationdate and (enddate is null or enddate>mass)) <= 0
 then
     return null;
     end if;
 RETURN NEW;
END;
$checkacoonmasses$
language plpgsql;

CREATE TRIGGER checkacolytesonmasses BEFORE INSERT ON acolytesmasses
FOR EACH ROW EXECUTE PROCEDURE checkacoonmasses();

--check acolytes dates
create or replace function checkacolytedates() returns trigger as
    $$
    declare
        birth date;
        death date;
        apostasy date;
        excomunice date;
        prev date;
        maxdate date;
        maxenddate date;
    begin
	IF ((SELECT COUNT(*) FROM priests WHERE laybrotherid = NEW.laybrotherid) >0)
	THEN
	 RETURN NULL;
        END IF;
        maxdate = (select max(inaugurationdate) from acolytes where laybrotherid=NEW.laybrotherid);
        if(maxdate is not null and (maxdate!=NEW.inaugurationdate or OLD.inaugurationdate is null))
            then maxenddate = (select max(enddate) from acolytes where laybrotherid = NEW.laybrotherid);
                if (maxenddate is null)
                    then return null;
                end if;
            end if;
        birth = (select dateofbirth from laybrothers where id=NEW.laybrotherid);
        death = (select deathdate from deaths where laybrotherid=NEW.laybrotherid);
        apostasy = (select apostasydate from apostates where laybrotherid=NEW.laybrotherid);
        excomunice = (select excommuniondate from excommunicated where laybrotherid=NEW.laybrotherid);
        prev = (select max(enddate) from acolytes where laybrotherid=NEW.laybrotherid);
        if((birth+interval '6 years')::date > new.inaugurationdate)
            then return null;
            end if;
        if(death is not null)
            then if(new.enddate is not null AND new.enddate > death)
                then return null;
                else if(new.inaugurationdate > death)
                    then return null;
                    end if;
                end if;
            end if;
        if(apostasy is not null)
            then if(new.enddate is not null AND new.enddate > apostasy)
                then return null;
                else if(new.inaugurationdate > apostasy)
                    then return null;
                    end if;
                end if;
            end if;
        if(excomunice is not null)
            then if(new.enddate is not null AND new.enddate > excomunice)
                then return null;
                else if(new.inaugurationdate > excomunice)
                    then return null;
                    end if;
                end if;
            end if;
        if(prev is not null AND prev >= NEW.inaugurationdate)
            then return null;
            end if;
        return new;
    end;
    $$language plpgsql;

create trigger checkacolytedates before insert or update on acolytes
    for each row execute procedure checkacolytedates();

--insert laybrothers
INSERT INTO laybrothers(forename,surname,gender,isparishioner,dateofbirth,motherid,fatherid,godfatherid,godmotherid) VALUES
('Britanni','Allison','F','True','1954-01-16',NULL,NULL,NULL,NULL),
('Zelda','Mcdaniel','F','False','1966-09-30',NULL,NULL,NULL,NULL),
('Rosalyn','Randolph','F','True','1971-04-14',NULL,NULL,NULL,NULL),
('Madison','Woods','F','True','1955-03-10',NULL,NULL,NULL,NULL),
('Delilah','Marshall','F','True','1964-02-24',NULL,NULL,NULL,NULL),
('Sasha','Mullins','F','False','1954-09-05',NULL,NULL,NULL,NULL),
('Jessica','Wilkins','F','True','1971-04-14',NULL,NULL,NULL,NULL),
('Olympia','Salazar','F','True','1951-05-08',NULL,NULL,NULL,NULL),
('Imogene','Blackburn','F','True','1965-10-27',NULL,NULL,NULL,NULL),
('Ruth','Hensley','F','False','1978-01-23',NULL,NULL,NULL,NULL),
('Rinah','Mcfadden','F','False','1963-03-27',NULL,NULL,NULL,NULL),
('Heather','Swanson','F','False','1959-02-24',NULL,NULL,NULL,NULL),
('Yvonne','Hansen','F','True','1973-04-23',NULL,NULL,NULL,NULL),
('Amy','Boyer','F','True','1984-08-07',NULL,NULL,NULL,NULL),
('Ina','Ramsey','F','False','1983-05-02',NULL,NULL,NULL,NULL),
('Genevieve','Peterson','F','False','1961-12-18',NULL,NULL,NULL,NULL),
('Nerea','Best','F','False','1974-02-13',NULL,NULL,NULL,NULL),
('Bryar','Campos','F','True','1984-08-14',NULL,NULL,NULL,NULL),
('Cheyenne','Cochran','F','False','1961-11-13',NULL,NULL,NULL,NULL),
('Serina','Baldwin','F','True','1984-05-17',NULL,NULL,NULL,NULL),
('Ingrid','Simon','F','True','1964-11-05',NULL,NULL,NULL,NULL),
('Sheila','Orr','F','True','1954-11-09',NULL,NULL,NULL,NULL),
('Sage','White','F','False','1955-04-03',NULL,NULL,NULL,NULL),
('Denise','Nielsen','F','True','1970-05-06',NULL,NULL,NULL,NULL),
('Astra','Newman','F','False','1957-09-06',NULL,NULL,NULL,NULL),
('Zelenia','Evans','F','True','1968-12-02',NULL,NULL,NULL,NULL),
('Audrey','Day','F','True','1953-08-01',NULL,NULL,NULL,NULL),
('Anastasia','Chavez','F','False','1987-05-26',NULL,NULL,NULL,NULL),
('TaShya','Mccullough','F','False','1958-11-16',NULL,NULL,NULL,NULL),
('Miranda','Craig','F','False','1964-08-21',NULL,NULL,NULL,NULL),
('Yolanda','Hines','F','True','1987-09-24',NULL,NULL,NULL,NULL),
('Sydnee','Odonnell','F','False','1953-06-04',NULL,NULL,NULL,NULL),
('Lois','Berger','F','False','1955-06-05',NULL,NULL,NULL,NULL),
('Maia','Hewitt','F','False','1984-11-28',NULL,NULL,NULL,NULL),
('Julie','Alvarado','F','False','1984-11-27',NULL,NULL,NULL,NULL),
('Melodie','Quinn','F','True','1977-09-03',NULL,NULL,NULL,NULL),
('Irma','James','F','True','1980-02-16',NULL,NULL,NULL,NULL),
('Noel','Richard','F','True','1969-02-05',NULL,NULL,NULL,NULL),
('Olympia','Frank','F','False','1983-12-22',NULL,NULL,NULL,NULL),
('Glenna','Waters','F','True','1985-02-15',NULL,NULL,NULL,NULL),
('Imogene','Murray','F','True','1977-10-22',NULL,NULL,NULL,NULL),
('Belle','Bernard','F','False','1987-05-01',NULL,NULL,NULL,NULL),
('Mona','Avery','F','True','1955-11-30',NULL,NULL,NULL,NULL),
('Tanisha','Valencia','F','True','1985-10-17',NULL,NULL,NULL,NULL),
('Avye','Shaffer','F','False','1957-07-17',NULL,NULL,NULL,NULL),
('Jenna','Koch','F','True','1959-11-10',NULL,NULL,NULL,NULL),
('Karyn','Hammond','F','False','1969-04-15',NULL,NULL,NULL,NULL),
('Riley','Hubbard','F','False','1964-11-03',NULL,NULL,NULL,NULL),
('Harriet','Dotson','F','False','1962-11-22',NULL,NULL,NULL,NULL),
('Willow','Harrell','F','False','1977-10-01',NULL,NULL,NULL,NULL),
('Holmes','Leonard','M','False','1957-04-18',NULL,NULL,NULL,NULL),
('Leo','Bartlett','M','False','1964-09-24',NULL,NULL,NULL,NULL),
('Ross','Duffy','M','True','1959-10-06',NULL,NULL,NULL,NULL),
('Basil','Velazquez','M','True','1959-07-27',NULL,NULL,NULL,NULL),
('Adrian','Sloan','M','False','1954-02-24',NULL,NULL,NULL,NULL),
('Asher','Battle','M','False','1956-12-14',NULL,NULL,NULL,NULL),
('Bert','Chandler','M','False','1974-04-08',NULL,NULL,NULL,NULL),
('Hamilton','Fischer','M','True','1953-06-20',NULL,NULL,NULL,NULL),
('Sawyer','Woodard','M','True','1950-07-11',NULL,NULL,NULL,NULL),
('Holmes','Knox','M','True','1978-09-04',NULL,NULL,NULL,NULL),
('Brian','Dickerson','M','False','1972-06-08',NULL,NULL,NULL,NULL),
('Coby','Parrish','M','False','1966-11-17',NULL,NULL,NULL,NULL),
('Cooper','Cooley','M','False','1953-09-11',NULL,NULL,NULL,NULL),
('Joseph','Avila','M','True','1969-10-20',NULL,NULL,NULL,NULL),
('Zachery','Barnes','M','False','1969-06-08',NULL,NULL,NULL,NULL),
('Oleg','Mcgowan','M','True','1982-05-25',NULL,NULL,NULL,NULL),
('Peter','Parsons','M','False','1954-09-29',NULL,NULL,NULL,NULL),
('Ivan','Klein','M','True','1983-05-11',NULL,NULL,NULL,NULL),
('Reuben','Camacho','M','False','1987-07-11',NULL,NULL,NULL,NULL),
('Shad','Daniel','M','False','1961-09-23',NULL,NULL,NULL,NULL),
('Arden','Mcclure','M','False','1966-11-24',NULL,NULL,NULL,NULL),
('Chaim','Tanner','M','False','1970-08-26',NULL,NULL,NULL,NULL),
('Ryan','Haynes','M','False','1966-02-23',NULL,NULL,NULL,NULL),
('Quamar','Sexton','M','False','1957-09-06',NULL,NULL,NULL,NULL),
('Keegan','Fowler','M','True','1985-10-31',NULL,NULL,NULL,NULL),
('Lucius','Dudley','M','False','1976-05-10',NULL,NULL,NULL,NULL),
('Ezekiel','West','M','True','1972-08-27',NULL,NULL,NULL,NULL),
('Jin','Weeks','M','False','1967-09-08',NULL,NULL,NULL,NULL),
('Connor','Pruitt','M','True','1959-08-07',NULL,NULL,NULL,NULL),
('Bevis','Harmon','M','False','1967-11-06',NULL,NULL,NULL,NULL),
('Walter','Moses','M','False','1966-06-17',NULL,NULL,NULL,NULL),
('Mannix','Bush','M','False','1950-12-24',NULL,NULL,NULL,NULL),
('Keane','Dennis','M','False','1950-10-22',NULL,NULL,NULL,NULL),
('Hoyt','Valdez','M','False','1962-12-31',NULL,NULL,NULL,NULL),
('Brennan','Flynn','M','True','1984-06-29',NULL,NULL,NULL,NULL),
('Noble','Dawson','M','True','1951-06-04',NULL,NULL,NULL,NULL),
('Drew','Fox','M','True','1964-05-08',NULL,NULL,NULL,NULL),
('Baker','Ryan','M','True','1983-04-25',NULL,NULL,NULL,NULL),
('Merritt','Chapman','M','False','1962-05-23',NULL,NULL,NULL,NULL),
('Craig','Goff','M','True','1984-06-09',NULL,NULL,NULL,NULL),
('Branden','Kent','M','True','1968-05-05',NULL,NULL,NULL,NULL),
('Yardley','Singleton','M','False','1958-07-15',NULL,NULL,NULL,NULL),
('Hyatt','Grimes','M','True','1965-10-24',NULL,NULL,NULL,NULL),
('Wyatt','Maddox','M','False','1967-06-23',NULL,NULL,NULL,NULL),
('Luke','Cameron','M','True','1975-11-14',NULL,NULL,NULL,NULL),
('Walter','Pacheco','M','False','1954-08-23',NULL,NULL,NULL,NULL),
('Marshall','Morrison','M','False','1984-10-05',NULL,NULL,NULL,NULL),
('Ralph','Santos','M','False','1962-10-26',NULL,NULL,NULL,NULL),
('Cyrus','Rose','M','True','1973-12-07',NULL,NULL,NULL,NULL),
('Elijah','Gonzales','M','False','1975-06-14',NULL,NULL,NULL,NULL),
('Cedric','Crosby','M','False','1980-11-09',NULL,NULL,NULL,NULL),
('Edward','Cruz','M','False','1955-08-08',NULL,NULL,NULL,NULL),
('Joseph','Wong','M','False','1966-05-29',NULL,NULL,NULL,NULL),
('Nasim','Lyons','M','False','1978-08-13',NULL,NULL,NULL,NULL),
('Keane','Castaneda','M','True','1950-05-22',NULL,NULL,NULL,NULL),
('Bert','Merritt','M','True','1981-09-27',NULL,NULL,NULL,NULL),
('Macon','Thompson','M','True','1979-03-01',NULL,NULL,NULL,NULL),
('Merritt','Stuart','M','True','1972-10-05',NULL,NULL,NULL,NULL),
('Walter','Mcneil','M','True','1989-02-21',NULL,NULL,NULL,NULL),
('Jordan','Nieves','M','False','1985-11-05',NULL,NULL,NULL,NULL),
('Rajah','Martin','M','True','1979-04-27',NULL,NULL,NULL,NULL),
('Clark','Medina','M','True','1987-12-10',NULL,NULL,NULL,NULL),
('Darius','Clayton','M','True','1955-07-27',NULL,NULL,NULL,NULL),
('Giacomo','Mullins','M','True','1952-10-30',NULL,NULL,NULL,NULL),
('Abel','Carver','M','True','1960-07-24',NULL,NULL,NULL,NULL),
('Walter','Hurst','M','False','1980-02-29',NULL,NULL,NULL,NULL),
('Hunter','Noel','M','True','1984-04-18',NULL,NULL,NULL,NULL),
('Otto','Mathis','M','False','1966-12-02',NULL,NULL,NULL,NULL),
('Warren','Talley','M','False','1951-08-15',NULL,NULL,NULL,NULL),
('Forrest','Coffey','M','True','1959-12-08',NULL,NULL,NULL,NULL),
('Eric','Conner','M','True','1981-07-24',NULL,NULL,NULL,NULL),
('Joel','Fuller','M','False','1979-10-23',NULL,NULL,NULL,NULL),
('Curran','Duke','M','True','1961-12-04',NULL,NULL,NULL,NULL),
('Matthew','Pace','M','True','1951-11-21',NULL,NULL,NULL,NULL),
('Brennan','Underwood','M','True','1962-06-07',NULL,NULL,NULL,NULL),
('Austin','Weiss','M','False','1963-03-31',NULL,NULL,NULL,NULL),
('Amir','Kent','M','True','1952-09-12',NULL,NULL,NULL,NULL),
('Cullen','Moreno','M','True','1980-02-01',NULL,NULL,NULL,NULL),
('Caldwell','Conley','M','False','1980-12-03',NULL,NULL,NULL,NULL),
('Ignatius','Cunningham','M','False','1962-03-15',NULL,NULL,NULL,NULL),
('Warren','Walters','M','True','1960-09-08',NULL,NULL,NULL,NULL),
('Lucian','Bryan','M','False','1972-04-05',NULL,NULL,NULL,NULL),
('Cedric','Levine','M','True','1975-03-08',NULL,NULL,NULL,NULL),
('Jeremy','Blackburn','M','True','1950-01-17',NULL,NULL,NULL,NULL),
('Prescott','Sandoval','M','True','1960-07-20',NULL,NULL,NULL,NULL),
('Griffin','Reese','M','False','1967-11-16',NULL,NULL,NULL,NULL),
('Merrill','Harris','M','True','1969-12-22',NULL,NULL,NULL,NULL),
('Brett','Ingram','M','True','1961-03-29',NULL,NULL,NULL,NULL),
('Guy','Crosby','M','True','1984-06-26',NULL,NULL,NULL,NULL),
('Lee','Castaneda','M','False','1954-03-12',NULL,NULL,NULL,NULL),
('Bevis','Carson','M','True','1957-07-15',NULL,NULL,NULL,NULL),
('Alvin','Nolan','M','True','1979-02-09',NULL,NULL,NULL,NULL),
('Coby','Kaufman','M','False','1976-10-02',NULL,NULL,NULL,NULL),
('Hayes','Howe','M','True','1950-03-25',NULL,NULL,NULL,NULL),
('Carl','Faulkner','M','True','1953-01-27',NULL,NULL,NULL,NULL),
('Yardley','Delaney','M','False','1960-06-21',NULL,NULL,NULL,NULL),
('Edward','English','M','True','1972-10-19',NULL,NULL,NULL,NULL),
('Ezra','Flores','M','True','1989-02-06',NULL,NULL,NULL,NULL),
('Wayne','Carver','M','False','1982-03-04',NULL,NULL,NULL,NULL),
('Galvin','Lowery','M','True','1987-07-18',NULL,NULL,NULL,NULL),
('Nash','Shelton','M','False','1972-01-06',NULL,NULL,NULL,NULL),
('Ryan','Henderson','M','True','1966-11-02',NULL,NULL,NULL,NULL),
('Zeus','Cochran','M','False','1958-01-21',NULL,NULL,NULL,NULL),
('Levi','Macdonald','M','False','1969-10-25',NULL,NULL,NULL,NULL),
('Gage','Baird','M','False','1979-10-27',NULL,NULL,NULL,NULL),
('Rigel','Reid','M','False','1971-10-15',NULL,NULL,NULL,NULL),
('Randall','Newman','M','True','1975-08-05',NULL,NULL,NULL,NULL),
('Hiram','Soto','M','False','1962-10-26',NULL,NULL,NULL,NULL),
('Wallace','Blake','M','True','1966-09-26',NULL,NULL,NULL,NULL),
('Cairo','Whitley','M','True','1988-02-23',NULL,NULL,NULL,NULL),
('Brennan','Savage','M','True','1980-06-08',NULL,NULL,NULL,NULL),
('Erasmus','Atkins','M','True','1987-02-04',NULL,NULL,NULL,NULL),
('Brian','Joyce','M','False','1985-03-02',NULL,NULL,NULL,NULL),
('Philip','Sanders','M','False','1979-01-30',NULL,NULL,NULL,NULL),
('Amos','Barrera','M','True','1978-11-01',NULL,NULL,NULL,NULL),
('Warren','Mclean','M','True','1953-01-29',NULL,NULL,NULL,NULL),
('Seth','Powers','M','True','1987-05-07',NULL,NULL,NULL,NULL),
('Demetrius','Dudley','M','True','1964-04-25',NULL,NULL,NULL,NULL),
('Ashton','Dillon','M','True','1988-06-21',NULL,NULL,NULL,NULL),
('Hayden','Suarez','M','False','1969-04-13',NULL,NULL,NULL,NULL),
('Wyatt','Hamilton','M','False','1971-12-02',NULL,NULL,NULL,NULL),
('Geoffrey','Foster','M','False','1962-10-21',NULL,NULL,NULL,NULL),
('Bruno','Bright','M','True','1974-01-13',NULL,NULL,NULL,NULL),
('Castor','Brewer','M','False','1953-01-25',NULL,NULL,NULL,NULL),
('Forrest','Buckner','M','False','1961-06-24',NULL,NULL,NULL,NULL),
('Kevin','Knowles','M','True','1955-12-25',NULL,NULL,NULL,NULL),
('Ivor','Guerrero','M','False','1951-11-05',NULL,NULL,NULL,NULL),
('Tyler','Sykes','M','False','1974-11-23',NULL,NULL,NULL,NULL),
('Aristotle','Sharp','M','True','1966-05-03',NULL,NULL,NULL,NULL),
('Howard','Decker','M','False','1985-03-11',NULL,NULL,NULL,NULL),
('Garrett','Hobbs','M','False','1966-03-13',NULL,NULL,NULL,NULL),
('Victor','Hensley','M','True','1959-05-17',NULL,NULL,NULL,NULL),
('Perry','Dalton','M','False','1952-10-03',NULL,NULL,NULL,NULL),
('Griffin','Pate','M','False','1968-10-18',NULL,NULL,NULL,NULL),
('Silas','Warner','M','False','1988-08-03',NULL,NULL,NULL,NULL),
('Kyle','Charles','M','True','1984-10-15',NULL,NULL,NULL,NULL),
('Raymond','Gross','M','False','1959-11-04',NULL,NULL,NULL,NULL),
('Alvin','Fitzpatrick','M','True','1960-02-22',NULL,NULL,NULL,NULL),
('Noble','Jefferson','M','False','1958-02-06',NULL,NULL,NULL,NULL),
('Carlos','Frost','M','True','1964-10-07',NULL,NULL,NULL,NULL),
('Arsenio','Ballard','M','True','1977-09-02',NULL,NULL,NULL,NULL),
('Baxter','Shannon','M','False','1952-01-09',NULL,NULL,NULL,NULL),
('Jerome','Kelley','M','True','1982-04-26',NULL,NULL,NULL,NULL),
('Chadwick','Gilliam','M','True','1982-04-16',NULL,NULL,NULL,NULL),
('Rahim','Hyde','M','True','1987-01-22',NULL,NULL,NULL,NULL),
('Prescott','Fowler','M','True','1954-05-25',NULL,NULL,NULL,NULL),
('Zahir','Woodward','M','True','1989-08-10',NULL,NULL,NULL,NULL),
('Paul','Gonzalez','M','False','1960-02-19',NULL,NULL,NULL,NULL),
('Ulric','Emerson','M','False','1966-11-07',NULL,NULL,NULL,NULL),
('Brock','Kim','M','True','1981-09-14',NULL,NULL,NULL,NULL),
('Neil','Reeves','M','False','1975-12-05',NULL,NULL,NULL,NULL),
('Amos','Jordan','M','False','1989-10-27',NULL,NULL,NULL,NULL),
('Quamar','Gamble','M','False','1970-03-29',NULL,NULL,NULL,NULL),
('Brock','Goff','M','True','1959-09-16',NULL,NULL,NULL,NULL),
('Ulric','Wooten','M','True','1976-10-21',NULL,NULL,NULL,NULL),
('Jacob','Horton','M','True','1982-06-11',NULL,NULL,NULL,NULL),
('Asher','Holcomb','M','False','1977-05-31',NULL,NULL,NULL,NULL),
('Cody','Alvarez','M','True','1983-07-03',NULL,NULL,NULL,NULL),
('Kennan','Mcneil','M','False','1977-04-07',NULL,NULL,NULL,NULL),
('Walter','Gonzales','M','False','1987-02-23',NULL,NULL,NULL,NULL),
('Reed','Hayes','M','False','1982-04-12',NULL,NULL,NULL,NULL),
('Shad','Parrish','M','False','1978-12-16',NULL,NULL,NULL,NULL),
('Oren','Silva','M','True','1963-03-02',NULL,NULL,NULL,NULL),
('Abbot','Hull','M','False','1974-12-29',NULL,NULL,NULL,NULL),
('Edward','Mitchell','M','False','1953-02-18',NULL,NULL,NULL,NULL),
('Rigel','Vaughan','M','False','1959-01-04',NULL,NULL,NULL,NULL),
('Cade','Woodward','M','True','1957-10-10',NULL,NULL,NULL,NULL),
('Norman','Morgan','M','True','1960-06-30',NULL,NULL,NULL,NULL),
('Oliver','Odom','M','False','1961-08-18',NULL,NULL,NULL,NULL),
('Roth','Glass','M','False','1955-07-15',NULL,NULL,NULL,NULL),
('Hyatt','Holloway','M','False','1966-05-09',NULL,NULL,NULL,NULL),
('Keane','Cox','M','False','1978-05-08',NULL,NULL,NULL,NULL),
('Cedric','Hampton','M','True','1968-04-02',NULL,NULL,NULL,NULL),
('Marvin','Hodges','M','True','1961-03-25',NULL,NULL,NULL,NULL),
('Tyler','Sargent','M','False','1962-10-05',NULL,NULL,NULL,NULL),
('Tobias','Wilkinson','M','False','1989-04-24',NULL,NULL,NULL,NULL),
('Quinlan','Key','M','False','1973-10-28',NULL,NULL,NULL,NULL),
('Brett','Good','M','False','1951-08-10',NULL,NULL,NULL,NULL),
('Martin','Conway','M','True','1979-07-12',NULL,NULL,NULL,NULL),
('Keith','Clayton','M','True','1984-07-26',NULL,NULL,NULL,NULL),
('Alfonso','Hendrix','M','False','1985-07-02',NULL,NULL,NULL,NULL),
('Grady','Manning','M','True','1957-04-09',NULL,NULL,NULL,NULL),
('Emmanuel','Vaughan','M','True','1959-06-07',NULL,NULL,NULL,NULL),
('Malcolm','Reynolds','M','False','1964-04-11',NULL,NULL,NULL,NULL),
('Branden','Castro','M','True','1982-06-23',NULL,NULL,NULL,NULL),
('Caesar','Daugherty','M','False','1958-07-28',NULL,NULL,NULL,NULL),
('Drake','Atkins','M','True','1974-01-31',NULL,NULL,NULL,NULL),
('Mark','Mclean','M','True','1985-12-26',NULL,NULL,NULL,NULL),
('Perry','Johnston','M','False','1968-03-29',NULL,NULL,NULL,NULL),
('Giacomo','Chaney','M','False','1953-10-21',NULL,NULL,NULL,NULL),
('Stone','Cain','M','False','1979-09-16',NULL,NULL,NULL,NULL),
('Cooper','Fitzpatrick','M','True','1971-05-14',NULL,NULL,NULL,NULL),
('Alec','Brown','M','True','1989-08-06',NULL,NULL,NULL,NULL),
('Francis','Townsend','M','False','1963-05-19',NULL,NULL,NULL,NULL),
('Jasper','Dale','M','True','1969-05-08',NULL,NULL,NULL,NULL),
('Lucas','Lowe','M','True','1958-05-30',NULL,NULL,NULL,NULL),
('Dane','Colon','M','False','1963-01-30',NULL,NULL,NULL,NULL),
('Merrill','Clarke','M','False','1971-08-16',NULL,NULL,NULL,NULL),
('Raymond','Harrell','M','True','1971-05-10',NULL,NULL,NULL,NULL),
('Wang','Swanson','M','True','1959-08-07',NULL,NULL,NULL,NULL),
('Stephen','Walsh','M','False','1971-04-07',NULL,NULL,NULL,NULL),
('Samson','Sweeney','M','False','1966-12-16',NULL,NULL,NULL,NULL),
('Alan','Henson','M','True','1956-06-13',NULL,NULL,NULL,NULL),
('Mark','Tran','M','False','1984-04-07',NULL,NULL,NULL,NULL),
('Matthew','Burt','M','True','1962-01-11',NULL,NULL,NULL,NULL),
('Reed','Hodges','M','False','1979-12-27',NULL,NULL,NULL,NULL),
('Quinlan','Clay','M','True','1970-11-16',NULL,NULL,NULL,NULL),
('Prescott','Duffy','M','False','1972-09-01',NULL,NULL,NULL,NULL),
('Wade','Mcneil','M','False','1981-03-27',NULL,NULL,NULL,NULL),
('Linus','Osborne','M','False','1971-01-11',NULL,NULL,NULL,NULL),
('Murphy','Jimenez','M','True','1975-02-05',NULL,NULL,NULL,NULL),
('Victor','Leonard','M','True','1951-01-23',NULL,NULL,NULL,NULL),
('Calvin','Cannon','M','False','1963-08-03',NULL,NULL,NULL,NULL),
('Joshua','Snider','M','False','1951-03-01',NULL,NULL,NULL,NULL),
('Brent','Owens','M','True','1984-01-19',NULL,NULL,NULL,NULL),
('Hunter','Rush','M','False','1989-09-24',NULL,NULL,NULL,NULL),
('Isaiah','Mccullough','M','False','1960-02-21',NULL,NULL,NULL,NULL),
('Randall','Hatfield','M','False','1967-04-22',NULL,NULL,NULL,NULL),
('Yardley','Wallace','M','True','1963-03-05',NULL,NULL,NULL,NULL),
('Judah','Moss','M','False','1980-10-16',NULL,NULL,NULL,NULL),
('Cody','Fuller','M','False','1986-06-24',NULL,NULL,NULL,NULL),
('Thor','Walls','M','False','1958-03-23',NULL,NULL,NULL,NULL),
('Knox','Mcdowell','M','False','1955-05-29',NULL,NULL,NULL,NULL),
('Buckminster','Diaz','M','False','1952-04-24',NULL,NULL,NULL,NULL),
('Dane','Duncan','M','True','1963-04-12',NULL,NULL,NULL,NULL),
('Cade','Kelly','M','True','1979-11-03',NULL,NULL,NULL,NULL),
('Chancellor','Ayala','M','True','1981-11-22',NULL,NULL,NULL,NULL),
('Zeph','Fowler','M','False','1959-07-21',NULL,NULL,NULL,NULL),
('Steel','Silva','M','True','1987-05-25',NULL,NULL,NULL,NULL),
('Roth','Ferguson','M','True','1965-04-15',NULL,NULL,NULL,NULL),
('Sebastian','Madden','M','True','1970-01-31',NULL,NULL,NULL,NULL),
('Ezra','Mendez','M','False','1966-05-24',NULL,NULL,NULL,NULL),
('Hilel','Good','M','False','1963-06-14',NULL,NULL,NULL,NULL),
('Walter','Mccarty','M','False','1952-05-11',NULL,NULL,NULL,NULL),
('Lane','Salinas','M','True','1974-11-17',NULL,NULL,NULL,NULL),
('Palmer','Solis','M','False','1971-01-08',NULL,NULL,NULL,NULL),
('Timothy','Gutierrez','M','True','1976-01-01',NULL,NULL,NULL,NULL),
('Quinn','Turner','M','True','1953-04-28',NULL,NULL,NULL,NULL),
('Dane','Holmes','M','True','1970-02-03',NULL,NULL,NULL,NULL),
('Erich','Wells','M','False','1958-01-01',NULL,NULL,NULL,NULL),
('Kelly','Frost','M','False','1976-12-02',NULL,NULL,NULL,NULL),
('Elvis','Ballard','M','False','1951-01-18',NULL,NULL,NULL,NULL),
('Kareem','Bruce','M','False','1987-03-26',NULL,NULL,NULL,NULL),
('Quentin','Peterson','M','False','1963-04-10',NULL,NULL,NULL,NULL),
('Phelan','Gilliam','M','False','1975-09-26',NULL,NULL,NULL,NULL),
('Lance','Farrell','M','True','1974-11-07',NULL,NULL,NULL,NULL),
('Clinton','Golden','M','False','1988-02-03',NULL,NULL,NULL,NULL),
('Quinn','Clayton','M','True','1975-01-21',NULL,NULL,NULL,NULL),
('Mufutau','Jordan','M','False','1967-10-26',NULL,NULL,NULL,NULL),
('Lester','Wise','M','False','1961-12-24',NULL,NULL,NULL,NULL),
('Jenna','Talley','F','True','1973-07-10',NULL,NULL,NULL,NULL),
('Maxine','Fowler','F','False','1983-04-13',NULL,NULL,NULL,NULL),
('Vivien','Kent','F','False','1964-09-05',NULL,NULL,NULL,NULL),
('Clare','Skinner','F','True','1970-03-06',NULL,NULL,NULL,NULL),
('Cameron','Rivers','F','False','1959-04-25',NULL,NULL,NULL,NULL),
('Jocelyn','Lamb','F','False','1989-01-11',NULL,NULL,NULL,NULL),
('Olympia','Moore','F','True','1958-10-23',NULL,NULL,NULL,NULL),
('Mariam','Lester','F','True','1982-01-16',NULL,NULL,NULL,NULL),
('Kylan','Patel','F','True','1954-12-18',NULL,NULL,NULL,NULL),
('Erin','Gillespie','F','False','1969-03-30',NULL,NULL,NULL,NULL),
('Briar','Eaton','F','False','1959-04-16',NULL,NULL,NULL,NULL),
('Clio','Wise','F','False','1977-12-02',NULL,NULL,NULL,NULL),
('Alea','Crosby','F','False','1972-03-10',NULL,NULL,NULL,NULL),
('Emerald','Thomas','F','True','1975-09-05',NULL,NULL,NULL,NULL),
('Josephine','Lopez','F','True','1978-07-07',NULL,NULL,NULL,NULL),
('Callie','Leon','F','True','1973-12-16',NULL,NULL,NULL,NULL),
('Willow','Carson','F','False','1971-02-14',NULL,NULL,NULL,NULL),
('Reagan','Owen','F','False','1952-01-28',NULL,NULL,NULL,NULL),
('Cassady','Lynn','F','False','1971-08-23',NULL,NULL,NULL,NULL),
('Cassady','Carver','F','True','1984-11-10',NULL,NULL,NULL,NULL),
('Yael','Fischer','F','False','1978-08-26',NULL,NULL,NULL,NULL),
('Willow','Simpson','F','False','1974-11-11',NULL,NULL,NULL,NULL),
('Daria','Berger','F','True','1989-08-06',NULL,NULL,NULL,NULL),
('Tanya','Leblanc','F','True','1954-07-23',NULL,NULL,NULL,NULL),
('Aiko','Henson','F','True','1968-10-12',NULL,NULL,NULL,NULL),
('Blair','Lane','F','False','1952-05-29',NULL,NULL,NULL,NULL),
('Maris','Dalton','F','True','1987-05-10',NULL,NULL,NULL,NULL),
('Naida','Sparks','F','True','1961-05-02',NULL,NULL,NULL,NULL),
('Clio','Poole','F','False','1970-06-25',NULL,NULL,NULL,NULL),
('Quemby','Gilmore','F','False','1970-04-26',NULL,NULL,NULL,NULL),
('Ifeoma','Armstrong','F','True','1957-09-14',NULL,NULL,NULL,NULL),
('Susan','Burns','F','False','1961-05-23',NULL,NULL,NULL,NULL),
('Tanya','Cline','F','True','1959-09-24',NULL,NULL,NULL,NULL),
('Aiko','Watson','F','True','1962-10-01',NULL,NULL,NULL,NULL),
('Naomi','Klein','F','False','1959-07-07',NULL,NULL,NULL,NULL),
('Alma','Spence','F','True','1972-12-25',NULL,NULL,NULL,NULL),
('Jena','Small','F','False','1980-10-17',NULL,NULL,NULL,NULL),
('Cassidy','Bryan','F','False','1961-04-06',NULL,NULL,NULL,NULL),
('Nevada','Mayo','F','False','1968-06-15',NULL,NULL,NULL,NULL),
('Alice','Bryant','F','False','1964-06-16',NULL,NULL,NULL,NULL),
('Adrienne','Macdonald','F','False','1977-03-23',NULL,NULL,NULL,NULL),
('Latifah','York','F','True','1962-07-30',NULL,NULL,NULL,NULL),
('Sandra','Douglas','F','False','1965-07-22',NULL,NULL,NULL,NULL),
('Idola','Chang','F','True','1974-06-23',NULL,NULL,NULL,NULL),
('Christine','Black','F','False','1971-09-08',NULL,NULL,NULL,NULL),
('Kai','Green','F','False','1983-08-28',NULL,NULL,NULL,NULL),
('Willa','Smith','F','True','1960-02-19',NULL,NULL,NULL,NULL),
('Tashya','Mills','F','True','1984-03-19',NULL,NULL,NULL,NULL),
('Faith','Warner','F','True','1986-05-25',NULL,NULL,NULL,NULL),
('Zelda','Rosales','F','True','1961-12-06',NULL,NULL,NULL,NULL),
('Ariel','Delaney','F','True','1972-08-26',NULL,NULL,NULL,NULL),
('Alyssa','Clark','F','False','1979-03-21',NULL,NULL,NULL,NULL),
('Savannah','Sharp','F','True','1989-08-15',NULL,NULL,NULL,NULL),
('Audrey','Garrison','F','True','1963-04-13',NULL,NULL,NULL,NULL),
('Briar','Carver','F','False','1976-11-28',NULL,NULL,NULL,NULL),
('Kimberly','Mckee','F','True','1970-07-14',NULL,NULL,NULL,NULL),
('Martena','Willis','F','True','1981-08-09',NULL,NULL,NULL,NULL),
('Quail','White','F','True','1971-08-30',NULL,NULL,NULL,NULL),
('Ivy','Gross','F','False','1986-05-21',NULL,NULL,NULL,NULL),
('Tara','Sargent','F','True','1974-12-13',NULL,NULL,NULL,NULL),
('Inga','Peterson','F','False','1956-11-23',NULL,NULL,NULL,NULL),
('Kyra','Colon','F','True','1985-06-06',NULL,NULL,NULL,NULL),
('Uma','Navarro','F','True','1968-02-02',NULL,NULL,NULL,NULL),
('Madeson','Ramirez','F','True','1974-11-04',NULL,NULL,NULL,NULL),
('Portia','Duke','F','True','1952-03-03',NULL,NULL,NULL,NULL),
('Macy','Baker','F','True','1973-04-15',NULL,NULL,NULL,NULL),
('Alice','Ochoa','F','False','1964-07-16',NULL,NULL,NULL,NULL),
('Roanna','Torres','F','False','1963-07-17',NULL,NULL,NULL,NULL),
('Zelda','Parsons','F','True','1961-11-26',NULL,NULL,NULL,NULL),
('Nina','Sherman','F','True','1978-11-03',NULL,NULL,NULL,NULL),
('Sonya','Berger','F','True','1956-06-23',NULL,NULL,NULL,NULL),
('Cameran','Norman','F','False','1978-08-21',NULL,NULL,NULL,NULL),
('Yvonne','Caldwell','F','True','1988-07-07',NULL,NULL,NULL,NULL),
('Chloe','Pearson','F','True','1963-11-26',NULL,NULL,NULL,NULL),
('Melinda','Mcclain','F','True','1967-03-16',NULL,NULL,NULL,NULL),
('Rina','Norton','F','False','1950-01-19',NULL,NULL,NULL,NULL),
('Fatima','Hester','F','False','1950-04-07',NULL,NULL,NULL,NULL),
('Hedwig','Webster','F','True','1956-07-05',NULL,NULL,NULL,NULL),
('Stacy','Woodard','F','False','1971-02-13',NULL,NULL,NULL,NULL),
('Faith','Stevens','F','True','1978-10-25',NULL,NULL,NULL,NULL),
('Denise','Moreno','F','True','1963-11-25',NULL,NULL,NULL,NULL),
('Victoria','Saunders','F','True','1978-01-29',NULL,NULL,NULL,NULL),
('Sierra','Alford','F','False','1965-12-04',NULL,NULL,NULL,NULL),
('Kelly','Floyd','F','True','1969-02-02',NULL,NULL,NULL,NULL),
('Gail','Hendricks','F','True','1973-03-07',NULL,NULL,NULL,NULL),
('Kirestin','Murphy','F','True','1952-07-21',NULL,NULL,NULL,NULL),
('Maggie','Quinn','F','True','1966-12-21',NULL,NULL,NULL,NULL),
('Ciara','Barrett','F','False','1957-09-12',NULL,NULL,NULL,NULL),
('Iris','Knight','F','False','1961-02-04',NULL,NULL,NULL,NULL),
('Mia','Woodard','F','True','1973-01-21',NULL,NULL,NULL,NULL),
('Adara','Garcia','F','True','1954-02-16',NULL,NULL,NULL,NULL),
('Claire','Salinas','F','False','1972-08-09',NULL,NULL,NULL,NULL),
('Idola','Kirk','F','False','1972-11-07',NULL,NULL,NULL,NULL),
('Jane','Phelps','F','True','1968-10-25',NULL,NULL,NULL,NULL),
('Cheryl','Rice','F','False','1979-06-14',NULL,NULL,NULL,NULL),
('Colleen','Frank','F','False','1965-11-10',NULL,NULL,NULL,NULL),
('Cassady','Farrell','F','False','1970-10-31',NULL,NULL,NULL,NULL),
('Kelsey','Robertson','F','False','1958-06-20',NULL,NULL,NULL,NULL),
('Minerva','Schmidt','F','True','1953-04-12',NULL,NULL,NULL,NULL),
('Macy','Kemp','F','True','1971-09-05',NULL,NULL,NULL,NULL),
('Illana','Emerson','F','False','1972-04-01',NULL,NULL,NULL,NULL),
('Shaine','Jensen','F','True','1978-10-31',NULL,NULL,NULL,NULL),
('Hedda','Riggs','F','False','1981-07-02',NULL,NULL,NULL,NULL),
('Maite','Buckley','F','False','1985-01-26',NULL,NULL,NULL,NULL),
('Nell','Delgado','F','True','1981-06-02',NULL,NULL,NULL,NULL),
('Astra','Rosario','F','True','1960-02-16',NULL,NULL,NULL,NULL),
('Kimberley','Schwartz','F','False','1951-12-08',NULL,NULL,NULL,NULL),
('Francesca','Mayo','F','False','1982-09-29',NULL,NULL,NULL,NULL),
('Nita','Langley','F','True','1972-07-01',NULL,NULL,NULL,NULL),
('Chastity','Berry','F','True','1984-09-23',NULL,NULL,NULL,NULL),
('Natalie','Potts','F','True','1962-08-27',NULL,NULL,NULL,NULL),
('Cameron','Hatfield','F','True','1984-09-16',NULL,NULL,NULL,NULL),
('Glenna','Warren','F','True','1953-02-07',NULL,NULL,NULL,NULL),
('Celeste','Osborn','F','False','1979-02-25',NULL,NULL,NULL,NULL),
('Mercedes','Conrad','F','False','1950-12-12',NULL,NULL,NULL,NULL),
('Aretha','Sanders','F','True','1984-12-07',NULL,NULL,NULL,NULL),
('Aimee','Wright','F','True','1970-04-09',NULL,NULL,NULL,NULL),
('Lacey','Savage','F','True','1980-05-11',NULL,NULL,NULL,NULL),
('Vivian','Hogan','F','True','1968-05-30',NULL,NULL,NULL,NULL),
('Iona','Simpson','F','True','1955-07-01',NULL,NULL,NULL,NULL),
('Kerry','Schmidt','F','True','1972-03-26',NULL,NULL,NULL,NULL),
('Yetta','Burton','F','False','1960-12-22',NULL,NULL,NULL,NULL),
('Oprah','Fischer','F','True','1956-03-15',NULL,NULL,NULL,NULL),
('Martina','Savage','F','False','1970-08-18',NULL,NULL,NULL,NULL),
('Maggy','Bernard','F','False','1959-06-06',NULL,NULL,NULL,NULL),
('Isabella','Erickson','F','False','1968-10-31',NULL,NULL,NULL,NULL),
('Serina','Martin','F','True','1967-05-16',NULL,NULL,NULL,NULL),
('Isabella','Jarvis','F','True','1973-01-05',NULL,NULL,NULL,NULL),
('Lacey','Carlson','F','False','1952-07-02',NULL,NULL,NULL,NULL),
('Sonya','Mullins','F','False','1966-01-05',NULL,NULL,NULL,NULL),
('Laura','Brown','F','True','1969-01-02',NULL,NULL,NULL,NULL),
('Jillian','Taylor','F','True','1987-09-17',NULL,NULL,NULL,NULL),
('Mallory','Dean','F','True','1972-09-10',NULL,NULL,NULL,NULL),
('Zelenia','Becker','F','True','1963-02-21',NULL,NULL,NULL,NULL),
('Casey','Norton','F','False','1963-08-25',NULL,NULL,NULL,NULL),
('Gisela','Cortez','F','True','1982-06-24',NULL,NULL,NULL,NULL),
('Rae','Joyner','F','False','1954-10-04',NULL,NULL,NULL,NULL),
('Iona','Rush','F','True','1988-03-11',NULL,NULL,NULL,NULL),
('Ainsley','Massey','F','True','1989-03-19',NULL,NULL,NULL,NULL),
('Ava','Robbins','F','False','1984-04-29',NULL,NULL,NULL,NULL),
('Ulla','Keith','F','False','1960-11-06',NULL,NULL,NULL,NULL),
('Alana','Castro','F','True','1979-03-23',NULL,NULL,NULL,NULL),
('Phoebe','Norris','F','True','1980-12-09',NULL,NULL,NULL,NULL),
('Fallon','Fisher','F','True','1957-01-22',NULL,NULL,NULL,NULL),
('Zenaida','Payne','F','False','1983-06-01',NULL,NULL,NULL,NULL),
('Daphne','Wilson','F','True','1956-03-31',NULL,NULL,NULL,NULL),
('Penelope','Sanders','F','False','1964-09-22',NULL,NULL,NULL,NULL),
('Ila','Hughes','F','False','1980-12-16',NULL,NULL,NULL,NULL),
('Amethyst','Short','F','False','1971-02-10',NULL,NULL,NULL,NULL),
('Lara','William','F','False','1957-01-26',NULL,NULL,NULL,NULL),
('Samantha','Hale','F','True','1964-06-14',NULL,NULL,NULL,NULL),
('Rhona','Ramsey','F','False','1972-11-29',NULL,NULL,NULL,NULL),
('Amelia','Mcdaniel','F','False','1951-08-28',NULL,NULL,NULL,NULL),
('Sheila','Tyson','F','True','1987-08-13',NULL,NULL,NULL,NULL),
('Martina','Hart','F','False','1972-07-27',NULL,NULL,NULL,NULL),
('Lunea','Serrano','F','False','1985-06-19',NULL,NULL,NULL,NULL),
('Pandora','Rhodes','F','True','1968-04-22',NULL,NULL,NULL,NULL),
('Leigh','Sharp','F','False','1982-09-04',NULL,NULL,NULL,NULL),
('Nell','Leblanc','F','False','1952-04-07',NULL,NULL,NULL,NULL),
('Yeo','Hobbs','F','True','1957-06-03',NULL,NULL,NULL,NULL),
('Delilah','Stevenson','F','True','1968-01-05',NULL,NULL,NULL,NULL),
('Sade','Copeland','F','False','1964-04-01',NULL,NULL,NULL,NULL),
('Jade','Velez','F','False','1977-03-22',NULL,NULL,NULL,NULL),
('Alea','Santos','F','False','1989-09-06',NULL,NULL,NULL,NULL),
('Ariana','Zamora','F','False','1979-01-21',NULL,NULL,NULL,NULL),
('Dana','Atkinson','F','False','1974-10-02',NULL,NULL,NULL,NULL),
('Jaquelyn','Gould','F','False','1952-05-06',NULL,NULL,NULL,NULL),
('Josephine','Summers','F','True','1974-05-27',NULL,NULL,NULL,NULL),
('Gemma','Petersen','F','True','1985-05-08',NULL,NULL,NULL,NULL),
('Ariana','Jensen','F','True','1959-12-15',NULL,NULL,NULL,NULL),
('Megan','Boyd','F','False','1953-09-03',NULL,NULL,NULL,NULL),
('Clare','Preston','F','False','1955-08-10',NULL,NULL,NULL,NULL),
('Mariam','Gutierrez','F','True','1964-01-28',NULL,NULL,NULL,NULL),
('Diana','Frost','F','False','1984-07-05',NULL,NULL,NULL,NULL),
('Jennifer','Chang','F','True','1979-06-23',NULL,NULL,NULL,NULL),
('Ifeoma','Dean','F','True','1985-03-06',NULL,NULL,NULL,NULL),
('Chelsea','Odonnell','F','False','1987-03-26',NULL,NULL,NULL,NULL),
('Colleen','Hanson','F','True','1975-07-04',NULL,NULL,NULL,NULL),
('Whitney','Chaney','F','False','1966-03-14',NULL,NULL,NULL,NULL),
('Kirby','Reilly','F','False','1978-04-21',NULL,NULL,NULL,NULL),
('Rebecca','Wiley','F','False','1957-08-02',NULL,NULL,NULL,NULL),
('Buffy','Bryan','F','True','1987-02-27',NULL,NULL,NULL,NULL),
('Kellie','Vang','F','False','1973-11-12',NULL,NULL,NULL,NULL),
('Pandora','Hensley','F','True','1967-07-16',NULL,NULL,NULL,NULL),
('Cassandra','Dale','F','False','1978-03-09',NULL,NULL,NULL,NULL),
('Cherokee','Pope','F','False','1951-01-03',NULL,NULL,NULL,NULL),
('Karina','Quinn','F','False','1962-08-27',NULL,NULL,NULL,NULL),
('Xena','Moses','F','False','1974-02-13',NULL,NULL,NULL,NULL),
('Erin','Griffin','F','False','1955-09-17',NULL,NULL,NULL,NULL),
('Xena','Dennis','F','False','1988-06-03',NULL,NULL,NULL,NULL),
('Mercedes','Cannon','F','False','1950-04-26',NULL,NULL,NULL,NULL),
('Miriam','Bailey','F','False','1976-09-05',NULL,NULL,NULL,NULL),
('Eleanor','Gray','F','True','1970-09-13',NULL,NULL,NULL,NULL),
('Maisie','Dale','F','True','1974-11-05',NULL,NULL,NULL,NULL),
('Ann','Chaney','F','False','1959-07-06',NULL,NULL,NULL,NULL),
('Inga','Valdez','F','True','1966-12-14',NULL,NULL,NULL,NULL),
('Halee','Hoffman','F','False','1966-12-07',NULL,NULL,NULL,NULL),
('Larissa','Fleming','F','False','1983-09-28',NULL,NULL,NULL,NULL),
('Ciara','Frost','F','True','1975-06-25',NULL,NULL,NULL,NULL),
('Emily','Arnold','F','False','1953-04-16',NULL,NULL,NULL,NULL),
('Carolyn','Bell','F'	 , true, '2006-12-25', 345, NULL ,NULL, NULL),
('Freya','Sparks','F'	 , true, '2002-04-01', 495, NULL ,NULL, NULL),
('Petra','Bird','F'	 , true, '2015-11-28', NULL, NULL ,NULL, NULL),
('Deborah','Glenn','F'	 , true, '2005-07-15', 478, 293 ,NULL, NULL),
('Cassady','Cooley','F'	 , true, '2007-07-12', 393, 245 ,NULL, NULL),
('Marny','Cain','F'	 , true, '2016-08-21', 326, NULL ,NULL, NULL),
('Eve','Shannon','F'	 , true, '2001-07-24', 395, 282 ,NULL, NULL),
('Rina','Sargent','F'	 , true, '2008-07-09', 362, 120 ,NULL, NULL),
('Joy','Young','F'	 , true, '2007-10-12', NULL, NULL ,NULL, NULL),
('Ursa','Combs','F'	 , true, '2019-06-27', NULL, 280 ,NULL, NULL),
('Angelica','Everett','F'	 , true, '2019-10-17', 465, 167 ,NULL, NULL),
('Camilla','Frost','F'	 , true, '2018-12-03', 300, 171 ,NULL, NULL),
('September','Parks','F'	 , true, '2017-06-07', 414, 232 ,NULL, NULL),
('Cecilia','Christian','F'	 , false, '2002-12-19', NULL, 233 ,NULL, NULL),
('Debra','Wilkerson','F'	 , true, '2004-04-21', NULL, 272 ,NULL, NULL),
('Nayda','Silva','F'	 , true, '2007-12-06', 306, 237 ,NULL, NULL),
('Denise','Kirk','F'	 , false, '2019-06-10', 432, 294 ,NULL, NULL),
('Stephanie','Lindsay','F'	 , true, '2002-10-02', NULL, NULL ,NULL, NULL),
('Wynne','Hammond','F'	 , true, '2010-11-23', 381, 104 ,NULL, NULL),
('Madonna','Goodman','F'	 , true, '2007-04-20', 390, 134 ,NULL, NULL),
('April','Howard','F'	 , true, '2008-10-17', NULL, 235 ,NULL, NULL),
('Breanna','Cabrera','F'	 , true, '2016-08-13', NULL, 179 ,NULL, NULL),
('Lael','Hebert','F'	 , true, '2014-12-23', 423, 158 ,NULL, NULL),
('Illana','Mcneil','F'	 , true, '2014-11-18', NULL, NULL ,NULL, NULL),
('Gillian','Olson','F'	 , true, '2000-06-23', 326, 234 ,NULL, NULL),
('Madaline','Wright','F'	 , true, '2019-10-19', 441, 220 ,NULL, NULL),
('Aphrodite','Simon','F'	 , true, '2008-04-11', 335, NULL ,NULL, NULL),
('Robin','Barry','F'	 , true, '2006-07-28', 497, 225 ,NULL, NULL),
('Catherine','Byers','F'	 , true, '2003-11-15', 300, 248 ,NULL, NULL),
('Priscilla','Newman','F'	 , true, '2018-02-11', 467, 283 ,NULL, NULL),
('Bertha','Cervantes','F'	 , true, '2002-01-22', NULL, NULL ,NULL, NULL),
('Autumn','Mcclain','F'	 , true, '2011-04-22', 497, 165 ,NULL, NULL),
('Jocelyn','Charles','F'	 , true, '2009-06-11', NULL, NULL ,NULL, NULL),
('Ayanna','Garza','F'	 , true, '2013-05-19', 332, NULL ,NULL, NULL),
('Maris','Love','F'	 , true, '2002-08-22', NULL, NULL ,NULL, NULL),
('Molly','Dickson','F'	 , true, '2008-02-24', 343, 250 ,NULL, NULL),
('Brielle','Flowers','F'	 , true, '2003-01-07', 381, 207 ,NULL, NULL),
('Pascale','Adams','F'	 , true, '2018-09-28', 307, 194 ,NULL, NULL),
('MacKensie','Bean','F'	 , true, '2009-09-13', 357, NULL ,NULL, NULL),
('Blair','Britt','F'	 , true, '2010-07-14', 323, NULL ,NULL, NULL),
('Keelie','Harrison','F'	 , true, '2004-09-28', NULL, 264 ,NULL, NULL),
('Isadora','Trevino','F'	 , true, '2008-11-02', 474, NULL ,NULL, NULL),
('Whoopi','Castaneda','F'	 , true, '2011-12-24', 356, 164 ,NULL, NULL),
('Jaden','Patterson','F'	 , true, '2007-11-13', 439, 205 ,NULL, NULL),
('Clio','Strickland','F'	 , true, '2006-09-18', NULL, 107 ,NULL, NULL),
('Blythe','Bartlett','F'	 , true, '2011-07-11', 392, NULL ,NULL, NULL),
('Renee','Glass','F'	 , true, '2017-10-14', 372, 238 ,NULL, NULL),
('Sacha','Henry','F'	 , true, '2007-07-09', 331, 219 ,NULL, NULL),
('Jessamine','Franklin','F'	 , true, '2016-10-20', 476, 160 ,NULL, NULL),
('Mechelle','Kelly','F'	 , true, '2007-05-20', NULL, 127 ,NULL, NULL),
('Quintessa','Carlson','F'	 , true, '2009-03-17', 457, 104 ,NULL, NULL),
('Delilah','Lucas','F'	 , true, '2003-07-16', NULL, NULL ,NULL, NULL),
('Mara','Shelton','F'	 , true, '2018-04-21', 446, 270 ,NULL, NULL),
('Evelyn','Baker','F'	 , true, '2005-04-06', NULL, 208 ,NULL, NULL),
('Yolanda','Christian','F'	 , true, '2011-05-08', 468, 198 ,NULL, NULL),
('Keely','Vinson','F'	 , true, '2013-03-19', NULL, 174 ,NULL, NULL),
('Lareina','Poole','F'	 , true, '2006-04-22', 367, 113 ,NULL, NULL),
('Jolene','Baxter','F'	 , false, '2001-10-22', 335, NULL ,NULL, NULL),
('Carla','Harris','F'	 , true, '2017-07-22', 353, NULL ,NULL, NULL),
('Kai','Bender','F'	 , true, '2019-05-06', 496, 285 ,NULL, NULL),
('Pandora','Bradford','F'	 , true, '2004-09-16', 496, 168 ,NULL, NULL),
('Sybil','Cervantes','F'	 , true, '2018-08-17', 439, NULL ,NULL, NULL),
('Giselle','Moon','F'	 , true, '2002-06-06', 472, 126 ,NULL, NULL),
('Beatrice','Villarreal','F'	 , true, '2008-09-14', 495, NULL ,NULL, NULL),
('Britanney','Bates','F'	 , false, '2000-10-23', 477, 113 ,NULL, NULL),
('Amena','Serrano','F'	 , true, '2000-12-04', 487, NULL ,NULL, NULL),
('Karly','Ayers','F'	 , true, '2013-03-22', NULL, 169 ,NULL, NULL),
('Chloe','Neal','F'	 , true, '2007-06-02', NULL, NULL ,NULL, NULL),
('Karina','Garrison','F'	 , true, '2009-07-09', 358, NULL ,NULL, NULL),
('Illana','Ford','F'	 , true, '2014-06-01', NULL, 103 ,NULL, NULL),
('Germane','Moss','F'	 , true, '2017-04-04', 346, 129 ,NULL, NULL),
('Shellie','Cain','F'	 , true, '2012-08-03', 373, NULL ,NULL, NULL),
('Aspen','Irwin','F'	 , true, '2010-10-24', NULL, 174 ,NULL, NULL),
('Gay','Mckenzie','F'	 , true, '2003-08-12', 376, 218 ,NULL, NULL),
('Chava','Sellers','F'	 , true, '2012-12-22', 372, 155 ,NULL, NULL),
('Briar','Moss','F'	 , true, '2001-03-03', NULL, NULL ,NULL, NULL),
('Blaine','Rosario','F'	 , true, '2000-04-27', 301, 167 ,NULL, NULL),
('Audra','Hyde','F'	 , true, '2006-11-03', 339, 206 ,NULL, NULL),
('Avye','Potter','F'	 , false, '2019-01-17', 422, 299 ,NULL, NULL),
('Portia','Townsend','F'	 , true, '2000-01-03', NULL, 168 ,NULL, NULL),
('Briar','Estrada','F'	 , true, '2015-07-16', 428, 214 ,NULL, NULL),
('Camille','Boone','F'	 , true, '2007-12-24', 464, 145 ,NULL, NULL),
('Aimee','Hardin','F'	 , false, '2008-08-11', NULL, NULL ,NULL, NULL),
('Lana','Garrison','F'	 , true, '2014-02-01', 361, NULL ,NULL, NULL),
('Dacey','Benson','F'	 , true, '2011-06-02', 420, 103 ,NULL, NULL),
('September','Chapman','F'	 , true, '2002-05-11', NULL, 249 ,NULL, NULL),
('Iona','Franco','F'	 , true, '2004-02-12', 320, 246 ,NULL, NULL),
('Giselle','Carr','F'	 , true, '2004-03-11', NULL, 128 ,NULL, NULL),
('Cheryl','Velez','F'	 , true, '2014-09-27', 446, NULL ,NULL, NULL),
('Reagan','Cox','F'	 , false, '2010-12-13', 447, 277 ,NULL, NULL),
('Isabelle','Bernard','F'	 , true, '2003-11-23', NULL, NULL ,NULL, NULL),
('Jena','Haynes','F'	 , true, '2009-05-25', 467, 254 ,NULL, NULL),
('Giselle','Gillespie','F'	 , true, '2012-02-08', 372, 117 ,NULL, NULL),
('Buffy','Gillespie','F'	 , true, '2002-05-21', 340, 153 ,NULL, NULL),

('Ima','Kirkland','F'	 , true, '2014-11-17', NULL, 141 , 135, 398),
('Yvette','Hart','F'	 , true, '2011-11-04', 488, 232 , 121, 393),
('Sloane','Larsen','F'	 , true, '2014-02-03', 342, 299 , 156, 367),
('Kristen','Whitfield','F'	 , true, '2018-07-07', NULL, NULL , 104, 400),
('Myra','Dodson','F'	 , false, '2009-07-28', 353, 138 , 106, 345),
('Xandra','Duran','F'	 , true, '2008-05-04', NULL, 122 , 111, 304),
('Michael','Bowman','M'	 , true, '2013-07-04', NULL, NULL , 184, 385),
('Lane','Wagner','M'	 , true, '2003-08-23', 334, 152 , 110, 368),
('Robert','Cardenas','M'	 , true, '2009-08-15', 388, NULL , 110, 308),
('Myles','Wooten','M'	 , true, '2007-04-06', 473, NULL , 174, 384),
('Abbot','Harrington','M'	 , true, '2018-02-22', NULL, 158 , 133, 353),
('Judah','Norman','M'	 , true, '2000-10-27', NULL, NULL , 200, 372),
('Cain','Landry','M'	 , true, '2003-07-06', NULL, 254 , 176, 389),
('Samuel','Merrill','M'	 , true, '2009-06-17', NULL, 143 , 195, 334),
('Armando','Jacobson','M'	 , true, '2008-09-22', 492, 276 , 183, 340),
('Adam','Stanley','M'	 , true, '2015-09-17', 461, NULL , 144, 369),
('Marshall','Hobbs','M'	 , true, '2019-02-05', NULL, 142 , 190, 316),
('Dolan','Massey','M'	 , true, '2011-07-12', 406, 278 , 161, 345),
('Dolan','Juarez','M'	 , true, '2002-09-16', 312, 230 , 182, 316),
('Tanner','Hart','M'	 , true, '2005-02-01', 446, 251 , 144, 339),
('Tobias','Carpenter','M'	 , true, '2004-03-06', 381, NULL , 112, 306),
('Cairo','Garrison','M'	 , true, '2014-05-02', NULL, NULL , 143, 348),
('Brett','Gonzalez','M'	 , true, '2007-04-06', NULL, 131 , 190, 304),
('Solomon','Grant','M'	 , true, '2015-09-21', 482, 285 , 115, 400),
('Byron','Gonzalez','M'	 , true, '2002-06-24', NULL, 197 , 111, 340),
('William','Herring','M'	 , true, '2018-07-13', 363, 232 , 183, 343),
('Chadwick','Donovan','M'	 , true, '2003-12-09', 394, 223 , 193, 334),
('Rooney','Freeman','M'	 , true, '2017-10-04', 471, NULL , 166, 368),
('William','Beck','M'	 , true, '2014-03-07', NULL, NULL , 175, 312),
('Castor','Joseph','M'	 , true, '2004-06-08', 453, 147 , 153, 309),
('Denton','Cash','M'	 , true, '2012-01-18', 305, 145 , 152, 349),
('Aristotle','Reeves','M'	 , true, '2002-02-04', NULL, NULL , 177, 393),
('Denton','Dickson','M'	 , true, '2016-05-17', 380, 278 , 164, 389),
('Sylvester','French','M'	 , true, '2015-11-04', NULL, 150 , 137, 398),
('Price','Nicholson','M'	 , true, '2013-05-23', 422, 116 , 105, 333),
('Sawyer','Warner','M'	 , true, '2000-07-27', 407, 146 , 136, 368),
('Vladimir','Holden','M'	 , true, '2013-08-12', NULL, 164 , 138, 330),
('Laith','Bright','M'	 , true, '2008-04-20', 417, NULL , 115, 328),
('Abel','Cotton','M'	 , true, '2019-10-17', 330, NULL , 133, 329),
('Caleb','Webster','M'	 , true, '2001-12-01', 302, 205 , 127, 396),
('Silas','Baker','M'	 , true, '2016-09-12', 458, NULL , 169, 361),
('Ezra','Callahan','M'	 , true, '2019-07-19', 302, 100 , 190, 313),
('Bert','Griffith','M'	 , true, '2005-07-14', 411, 107 , 195, 356),
('Garrett','Porter','M'	 , true, '2019-05-07', NULL, NULL , 180, 321),
('Randall','Hughes','M'	 , true, '2006-07-13', 421, 281 , 119, 384),
('Leroy','Hardin','M'	 , true, '2003-11-18', NULL, 274 , 129, 322),
('Micah','Avery','M'	 , true, '2001-10-20', NULL, NULL , 132, 305),
('Rigel','Burch','M'	 , true, '2015-11-02', NULL, 150 , 114, 348),
('Driscoll','Torres','M'	 , true, '2004-09-08', NULL, NULL , 145, 303),
('Ryan','Guzman','M'	 , true, '2014-02-03', NULL, 207 , 145, 349),
('Rajah','Nash','M'	 , true, '2012-10-15', 312, 199 , 135, 332),
('Donovan','Bowers','M'	 , true, '2007-05-10', NULL, 185 , 169, 372),
('Rogan','Orr','M'	 , true, '2018-08-11', 437, NULL , 162, 383),
('Eaton','Holland','M'	 , true, '2010-07-07', 456, 109 , 151, 394),
('Cameron','Aguirre','M'	 , true, '2013-12-19', 484, NULL , 112, 329),
('Oren','Paul','M'	 , true, '2008-09-11', NULL, 211 , 141, 332),
('Luke','James','M'	 , true, '2018-07-24', NULL, 233 , 190, 331),
('Oleg','Kim','M'	 , false, '2013-01-20', 486, 167 , 144, 336),
('Eagan','Gaines','M'	 , true, '2013-09-28', 356, NULL , 138, 375),
('Keane','Glenn','M'	 , true, '2019-02-12', 342, NULL , 156, 356),
('Cooper','Stevenson','M'	 , true, '2011-05-04', 461, NULL , 110, 384),
('Austin','Cruz','M'	 , true, '2007-11-24', 412, 177 , 130, 394),
('Daquan','Richards','M'	 , true, '2008-08-12', 328, 152 , 140, 343),
('Logan','Meadows','M'	 , true, '2016-08-11', 316, 289 , 141, 384),
('Cody','Dunn','M'	 , false, '2006-08-12', 418, 141 , 197, 385),
('Allen','Peterson','M'	 , true, '2019-06-28', 383, 109 , 185, 331),
('Keegan','Merrill','M'	 , true, '2011-04-01', 461, 145 , 116, 353),
('Nero','Madden','M'	 , true, '2004-10-06', 450, 225 , 155, 377),
('Grant','Newton','M'	 , true, '2007-07-19', 413, 292 , 187, 305),
('Talon','Fernandez','M'	 , true, '2000-02-21', NULL, NULL , 123, 398),
('Erich','Galloway','M'	 , true, '2017-08-04', 320, 295 , 186, 363),
('Dale','Warner','M'	 , true, '2016-02-06', NULL, 138 , 181, 375),
('Blaze','Mccormick','M'	 , true, '2014-08-12', 382, 169 , 193, 324),
('Herman','Wallace','M'	 , true, '2008-01-13', 430, 217 , 162, 382),
('Allen','Walker','M'	 , true, '2008-11-26', 485, NULL , 150, 369),
('Rogan','Hinton','M'	 , true, '2014-05-27', 386, NULL , 138, 360),
('Tucker','Booth','M'	 , true, '2014-12-03', 442, 159 , 104, 367),
('Edward','Estes','M'	 , false, '2002-02-16', 454, NULL , 153, 343),
('Jared','Mosley','M'	 , true, '2014-08-18', 485, 138 , 161, 393),
('Tobias','Blackburn','M'	 , true, '2011-08-10', NULL, NULL , 178, 358),
('Aaron','Tucker','M'	 , true, '2004-08-10', NULL, NULL , 129, 362),
('Jonas','Fitzgerald','M'	 , true, '2013-02-03', 336, 149 , 140, 396),
('Talon','Washington','M'	 , true, '2009-02-22', NULL, 122 , 166, 394),
('Ronan','Valdez','M'	 , true, '2007-06-11', 425, 282 , 125, 353),
('Amal','Dean','M'	 , true, '2016-08-11', NULL, 124 , 151, 347),
('Timon','Myers','M'	 , true, '2019-08-09', 388, 189 , 102, 336),
('Armand','Dunn','M'	 , true, '2017-02-01', 446, 198 , 161, 383),
('Samson','Cooke','M'	 , true, '2012-01-01', 412, 159 , 162, 306),
('Raja','Waters','M'	 , true, '2009-09-04', NULL, NULL , 158, 323),
('Jerry','Walls','M'	 , true, '2011-05-22', 416, 123 , 187, 360),
('Palmer','Herring','M'	 , true, '2018-03-17', 434, 260 , 143, 376),
('Logan','Moran','M'	 , true, '2010-03-05', NULL, 273 , 119, 346),
('Vladimir','Roberson','M'	 , true, '2005-01-24', NULL, 156 , 194, 323),
('Guy','Schultz','M'	 , true, '2008-10-15', NULL, 238 , 140, 355),
('Xander','Henderson','M'	 , true, '2019-03-01', 356, NULL , 167, 317),
('Uriah','Mcmahon','M'	 , true, '2011-02-07', NULL, 125 , 164, 347),
('Hashim','Nicholson','M'	 , true, '2008-03-24', 323, 190 , 131, 303),
('Lewis','Burch','M'	 , true, '2012-02-24', 445, 245 , 142, 396),
('Ali','Levy','M'	 , true, '2009-07-03', 329, NULL , 197, 366),

('Lucius','Bond','M'	 , true, '2017-12-01', 322, 284 ,NULL, NULL),
('Gannon','Carey','M'	 , true, '2005-11-18', 318, NULL ,NULL, NULL),
('Gray','Sheppard','M'	 , true, '2006-02-21', 444, 169 ,NULL, NULL),
('Linus','Lowe','M'	 , true, '2006-08-15', NULL, 266 ,NULL, NULL),
('Scott','Bullock','M'	 , true, '2012-02-28', 345, 181 ,346, 182),
('Jesse','Cunningham','M'	 , true, '2012-08-25', NULL, NULL ,NULL, NULL),
('Ryder','Oliver','M'	 , true, '2003-08-16', 368, 148 ,149, 367),
 ( 'Mieczyslaw', 'Kowalski', 'M', true, '1980-01-01', NULL, NULL ,NULL, NULL),
 ( 'Genowefa', 'Kowalska', 'F', true, '1980-02-01', NULL, NULL ,NULL, NULL),
 ( 'Marcel', 'Kowalski', 'M', false, '2000-01-01', 702, 701 ,NULL, NULL),
 ( 'Gertruda', 'Kowalska', 'F', true, '2000-02-01', 702, 701 ,NULL, NULL),
 ( 'Aleksandra', 'Kodral', 'F', true, '1980-04-01', NULL, NULL ,NULL, NULL),
 ( 'Krzysztof', 'Kodral', 'M', true, '2000-03-01', 705, NULL ,NULL, NULL),
 ( 'Miloslawa', 'Monkowska', 'F', true, '1960-01-01', NULL, NULL ,NULL, NULL),
 ( 'Bialorzab', 'Monkowski', 'M', true, '1960-02-01', NULL, NULL ,NULL, NULL),
 ( 'Krzysztofa', 'Borowska', 'F', true, '1985-01-01', 707, 708 ,NULL, NULL),
 ( 'Gniewomir', 'Borowski', 'M', false, '1960-03-01', NULL, NULL ,NULL, NULL),
 ( 'Zmyslawa', 'Borowska', 'F', true, '1960-06-10', NULL, NULL ,NULL, NULL),
 ( 'Grzegorz', 'Borowski', 'M', true, '1985-12-31', 711, 710 ,NULL, NULL),
 ( 'Lech', 'Borowski', 'M', false, '2010-11-24', 709, 712 ,NULL, NULL),
 ( 'Dzesika', 'Nowak', 'F', true, '1999-01-05', NULL, NULL ,NULL, NULL),
 ( 'Sebastian', 'Oleksa', 'M', true, '1995-10-10', NULL, NULL ,NULL, NULL),
 ( 'Anna', 'Nowak', 'F', true, '2014-01-01', 714, 715 ,NULL, NULL),
 ( 'Piotr', 'Nowak', 'M', true, '2014-10-01', 714, 715 ,NULL, NULL),
 ( 'Maria', 'Nowak', 'F', true, '2015-07-01', 714, 715 ,NULL, NULL),
 ( 'Krzysztof', 'Nowak', 'M', true, '2016-04-01', 714, 715 ,NULL, NULL),
 ( 'Katarzyna', 'Nowak', 'F', true, '2017-01-01', 714, 715 ,NULL, NULL),
 ( 'Andrzej', 'Nowak', 'M', true, '2017-10-01', 714, 715 ,NULL, NULL),
 ( 'Malgorzata', 'Nowak', 'F', true, '2018-07-01', 714, 715 ,NULL, NULL),
 ( 'Tomasz', 'Nowak', 'M', true, '2019-04-01', 714, 715 ,NULL, NULL),
 ( 'Agnieszka', 'Nowak', 'F', true, '2020-01-01', 714, 715 ,NULL, NULL),
 ( 'Jakub','Rogowski','M',true,'1958-07-06',NULL,NULL,NULL,NULL),
  ('Piotr','Mniszek','M',true,'1956-03-23',NULL,NULL,NULL,NULL),
  ('Patryk','Olechowski','M',true,'1957-06-21',NULL,NULL,NULL,NULL),
  ('Olgierd','Szymonik','M',true,'1951-08-28',NULL,NULL,NULL,NULL),
  ('Patryk','Olechowski','M',true,'1958-04-02',NULL,NULL,NULL,NULL),
  ('Pawel','Zewlakow','M',true,'1959-03-04',NULL,NULL,NULL,NULL),
  ('Olgierd','Olechowski','M',true,'1951-03-05',NULL,NULL,NULL,NULL),
  ('Ignacy','Kowal','M',true,'1959-10-16',NULL,NULL,NULL,NULL),
  ('Piotr','Szymonik','M',true,'1956-12-22',NULL,NULL,NULL,NULL),
  ('Ignacy','Kowalski','M',true,'1950-07-26',NULL,NULL,NULL,NULL),
  ('Ojciec','Mateusz','M',true,'1957-08-25',NULL,NULL,NULL,NULL),
  ('Aleksander','Pawlowski','M',true,'1968-10-12',NULL,NULL,NULL,NULL),
  ('Arnold','Kowalski','M',true,'1964-09-22',NULL,NULL,NULL,NULL),
  ('Szymon','Szymonik','M',true,'1962-09-13',NULL,NULL,NULL,NULL),
  ('Ignacy','Sobieraj','M',true,'1958-07-26',NULL,NULL,NULL,NULL),
  ('Olgierd','Mniszek','M',true,'1952-08-15',NULL,NULL,NULL,NULL),
  ('Mateusz','Markowski','M',true,'1964-04-09',NULL,NULL,NULL,NULL),
  ('Aleksander','Olechowski','M',true,'1964-02-23',NULL,NULL,NULL,NULL),
  ('Jan','Jonkisz','M',true,'1964-07-27',NULL,NULL,NULL,NULL),
  ('Mateusz','Mniszek','M',true,'1955-06-02',NULL,NULL,NULL,NULL);

-- =======================================
--insert priests
INSERT INTO "public".priests(laybrotherid, servicestart, serviceend)
VALUES (725, '1980-05-12','1990-01-07'),--1
       (726, '1981-05-12','1991-01-07'),--2
       (727, '1982-05-12','1992-01-07'),--3
       (728, '1983-05-12','1993-01-07'),--4
       (729, '1984-05-12','1994-01-07'),--5
       (730, '1985-05-12','1995-01-07'),--5
       (731, '1986-05-12','1996-01-07'),--7
       (732, '1987-05-12','1997-01-07'),--8
       (733, '1988-05-12','1998-01-07'),--9
       (734, '1989-05-12','1999-01-07'),--10
       (735, '1990-05-12','2000-01-07'),--11
       (736, '1990-05-12','2000-01-07'),--12
       (737, '1990-05-12','2000-01-07'),--13
       (738, '1990-05-12','2000-01-07'),--14
       (739, '1990-05-12','2000-01-07'),--15
       (740, '2000-01-01','2020-01-07'),--16
       (741, '2000-01-01','2020-01-07'),--17
       (742, '2000-01-01','2020-01-07'),--18
       (743, '2000-01-01',NULL),--19
       (744, '2000-01-01',NULL);--20


 -- =============================================================

--insert masstypes
INSERT INTO masstypes(type)
 VALUES
 ('Normal'),
 ('Celebration'),
 ('Latin'),
 ('Tridentine');

-- ================================
--insert intentions
INSERT INTO intentions(intention)
 VALUES
 ('Za ofiary smolenskie'),
 ('Za zdanie ID'),
 ('Za rodzine Kaminski'),
 ('Za rodzine Czarnecki'),
 ('Za rodzine Mazurek'),
 ('Za rodzine Makowski'),
 ('Za rodzine Gorski'),
 ('Za rodzine Borkowski'),
 ('Za rodzine Jakubowski'),
 ('Za rodzine Brzezinski');

-- ================================
--insert masses
INSERT INTO "public".masses(massdate,intentionid,offering,masstype, leadingpriestid)
VALUES

        ('2009-07-01',2,395.00,3,743),
        ('1996-04-10',1,423.00,2,736),
        ('2000-11-21',3,496.00,1,740),
        ('2002-01-08',2,795.00,3,740),
        ('2004-02-15',2,537.00,1,740),
        ('1995-06-03',3,746.00,2,734),
        ('2001-08-05',2,529.00,3,740),
        ('2005-03-28',2,748.00,1,743),
        ('2009-12-19',3,349.00,4,743),
        ('1993-01-18',2,774.00,2,734),
        ('1999-09-21',3,767.00,1,736),
        ('2008-04-19',1,399.00,1,743),
        ('2007-04-13',2,423.00,2,743),
        ('1997-06-24',1,718.00,2,736),
        ('2006-05-07',2,481.00,3,743),
        ('1999-02-03',3,625.00,1,736),
        ('1997-04-21',1,403.00,3,736),
        ('1994-08-19',1,432.00,4,734),
        ('1998-01-21',1,565.00,3,736),
        ('1999-12-22',3,490.00,4,736),
        ('1993-10-12',2,607.00,1,734),
        ('2005-08-13',3,743.00,3,743),
        ('1998-07-07',1,683.00,1,736),
        ('2009-09-03',3,614.00,1,743),
        ('2008-04-05',1,310.00,2,743),
        ('2003-02-18',1,319.00,1,740),
        ('1996-08-06',2,433.00,2,736),
        ('1996-04-11',3,627.00,3,736),
        ('2003-06-15',3,597.00,4,740),
        ('1995-03-19',3,670.00,4,734),
        ('1993-08-11',2,517.00,3,734),
        ('1994-07-20',2,308.00,2,734),
        ('2001-07-19',1,694.00,4,740),
        ('2005-02-12',2,577.00,2,743),
        ('1992-08-12',1,714.00,1,734),
        ('2000-05-04',1,425.00,4,740),
        ('1999-05-05',2,695.00,2,736),
        ('2005-03-23',1,789.00,2,743),
        ('2007-05-05',3,510.00,3,743),
        ('2003-02-18',1,467.00,4,740),
        ('1993-07-08',1,378.00,1,734),
        ('2002-11-13',2,308.00,4,740),
        ('1998-03-12',3,398.00,2,736),
        ('1994-07-04',2,612.00,3,734),
        ('1992-06-12',3,662.00,2,734),
        ('2004-02-05',1,360.00,1,740),
        ('1991-10-24',1,428.00,3,734),
        ('2001-12-24',1,659.00,2,740),
        ('2009-04-14',1,330.00,4,743),
        ('1994-06-13',2,416.00,3,734),
        ('2009-09-21',3,409.00,4,743),
        ('2009-05-16',3,458.00,1,743),
        ('2004-06-23',2,390.00,3,740),
        ('1990-08-20',3,631.00,3,734),
        ('2004-04-27',1,343.00,3,740),
        ('2003-12-25',2,664.00,3,740),
        ('1992-12-28',3,673.00,1,734),
        ('1990-01-03',3,620.00,3,734),
        ('1995-08-16',2,344.00,1,734),
        ('2004-11-22',3,566.00,2,740),
        ('1990-11-27',2,420.00,1,734),
        ('2000-04-03',3,767.00,4,740),
        ('2000-03-25',2,361.00,3,740),
        ('1991-09-23',1,565.00,2,734),
        ('2000-03-24',3,759.00,1,740),
        ('1995-10-04',2,431.00,2,734),
        ('2001-02-04',3,499.00,4,740),
        ('1990-08-25',1,785.00,2,734),
        ('1990-08-26',3,341.00,2,734),
        ('2000-09-04',2,508.00,2,740),
        ('2000-04-18',1,432.00,2,740),
        ('2003-04-01',2,722.00,1,740),
        ('1996-03-08',3,467.00,4,736),
        ('1991-02-25',1,545.00,3,734),
        ('2008-02-14',1,728.00,3,743),
        ('2002-03-25',1,379.00,1,740),
        ('1992-12-28',2,513.00,1,734),
        ('1991-01-01',1,361.00,2,734),
        ('2007-06-02',2,787.00,3,743),
        ('1996-09-14',3,589.00,4,736),
        ('1994-03-26',2,578.00,4,734),
        ('1995-11-18',3,532.00,4,734),
        ('2008-10-16',3,677.00,1,743),
        ('1990-08-23',3,320.00,1,734),
        ('1993-06-18',3,563.00,2,734),
        ('2004-05-24',3,392.00,1,740),
        ('1999-06-15',3,639.00,3,736),
        ('2000-07-11',3,789.00,4,740),
        ('1991-08-26',2,624.00,2,734),
        ('2004-11-10',1,404.00,2,740),
        ('2002-08-23',2,568.00,1,740),
        ('2007-07-13',2,383.00,1,743),
        ('1995-07-01',1,665.00,4,734),
        ('1999-11-18',3,677.00,3,736),
        ('1997-08-21',2,346.00,4,736),
        ('1995-05-08',1,306.00,2,734),
        ('2004-07-13',1,754.00,2,740),
        ('2008-07-10',3,750.00,4,743),
        ('1994-01-11',2,417.00,3,734),
        ('1998-10-22',2,578.00,3,736),
        ('2004-08-16',2,431.00,1,740),
        ('2008-10-15',2,737.00,1,743),
        ('2004-03-27',3,656.00,1,740),
        ('2004-01-12',1,336.00,1,740),
        ('2002-09-19',3,380.00,1,740),
        ('2003-10-07',1,409.00,1,740),
        ('2003-11-18',1,515.00,1,740),
        ('2007-03-16',2,705.00,1,743),
        ('2000-11-10',3,356.00,1,740),
        ('2007-09-16',1,753.00,1,743),
        ('2006-06-06',2,343.00,1,743),
        ('2009-12-14',2,481.00,1,743),
        ('2004-12-18',1,542.00,1,740),
        ('2008-03-15',3,785.00,1,743),
        ('2005-06-23',1,333.00,1,743),
        ('2000-11-05',2,627.00,1,740),
        ('2009-05-19',1,535.00,1,743),
        ('2005-07-09',3,735.00,1,743),
        ('2001-05-04',1,438.00,1,740),
        ('2000-03-05',2,361.00,1,740),
        ('2004-06-03',2,507.00,1,740),
        ('2002-10-05',3,471.00,1,740),
        ('2008-07-02',1,655.00,1,743),
        ('2002-12-07',1,333.00,1,740),
        ('2008-07-17',3,382.00,1,743),
        ('2003-10-04',2,343.00,1,740),
        ('2004-06-11',3,424.00,1,740),
        ('2004-12-01',2,494.00,1,740),
        ('2002-10-17',3,323.00,1,740),
        ('2002-05-05',3,322.00,1,740),
        ('2001-05-01',1,535.00,1,740),
        ('2003-11-07',2,572.00,1,740),
        ('2004-08-13',3,329.00,2,740),
        ('2003-12-10',2,702.00,1,740),
        ('2002-02-24',3,550.00,1,740),
        ('2003-03-16',3,324.00,3,740),
        ('2007-05-05',2,798.00,1,743),
        ('2001-02-05',1,545.00,1,740),
        ('2003-07-09',3,476.00,4,740),
        ('2003-06-18',3,357.00,1,740),
        ('2001-03-03',3,579.00,3,740),
        ('2002-04-09',1,558.00,1,740),
        ('2003-01-15',1,714.00,4,740),
        ('2000-05-09',2,530.00,3,740),
        ('2007-12-17',3,413.00,1,743),
        ('2005-08-02',3,581.00,2,743),
        ('2009-06-20',2,568.00,1,743),
        ('2006-05-24',1,500.00,1,743),
        ('2005-10-02',1,500.00,1,743),
        ('2004-02-03',3,303.00,1,740),
        ('2007-04-20',3,524.00,1,743),
        ('2008-11-24',3,760.00,1,743),
        ('2009-04-26',1,790.00,1,743),
        ('2004-03-07',3,648.00,1,740),
        ('2000-06-16',3,482.00,3,740),
        ('2008-05-11',1,610.00,3,743),
        ('2003-09-03',1,660.00,1,740),
        ('2002-11-15',1,301.00,1,740),
        ('2005-06-16',1,743.00,1,743),
        ('2006-11-16',3,385.00,1,743),
        ('2007-12-27',3,591.00,2,743),
        ('2006-08-05',2,631.00,2,743),
        ('2006-05-11',1,694.00,1,743),
        ('2007-05-13',2,499.00,1,743),
        ('2001-01-06',1,399.00,3,740),
        ('2000-07-08',1,717.00,3,740),
        ('2005-06-23',3,389.00,3,743),
        ('2002-04-01',2,548.00,1,740),
        ('2001-12-17',2,528.00,1,740),
        ('2000-07-23',2,582.00,1,740),
        ('2007-02-13',2,692.00,1,743),
        ('2007-11-14',1,632.00,4,743),
        ('2004-03-09',3,372.00,4,740),
        ('2008-07-20',1,559.00,1,743),
        ('2005-07-20',2,671.00,4,743),
        ('2002-01-04',3,603.00,3,740),
        ('2000-11-16',2,740.00,3,740),
        ('2000-02-14',1,401.00,2,740),
        ('2008-10-28',1,315.00,1,743),
        ('2008-03-20',2,459.00,1,743),
        ('2000-12-25',2,560.00,1,740),
        ('2009-05-06',2,385.00,1,743),
        ('2002-09-20',3,595.00,1,740),
        ('2007-08-17',3,344.00,1,743),
        ('2004-05-06',1,562.00,1,740),
        ('2007-07-01',1,550.00,1,743),
        ('2000-01-08',1,432.00,1,740),
        ('2001-05-22',3,335.00,1,740),
        ('2006-04-26',2,628.00,1,743),
        ('2007-08-15',3,763.00,1,743),
        ('2006-03-17',2,660.00,1,743),
        ('2002-09-15',2,419.00,1,740),
        ('2008-05-22',2,518.00,1,743),
        ('2001-11-01',2,716.00,1,740),
        ('2008-01-10',2,410.00,1,743),
        ('2008-10-21',1,529.00,1,743),
        ('2001-11-05',2,348.00,1,740),
        ('2007-08-05',3,795.00,1,743),
        ('2004-11-04',2,646.00,1,740),
        ('2003-06-02',2,742.00,1,740),
        ('2011-08-11',3,721.00,1,744),
        ('2014-05-26',1,304.00,1,744),
        ('2017-08-28',2,675.00,1,743),
        ('2011-08-10',1,374.00,1,744),
        ('2010-03-08',3,388.00,1,744),
        ('2010-09-27',3,461.00,1,744),
        ('2015-10-15',2,565.00,1,744),
        ('2013-12-19',3,769.00,1,744),
        ('2012-06-11',1,564.00,1,744),
        ('2018-10-05',2,709.00,1,733),
        ('2016-11-03',3,521.00,1,733),
        ('2012-04-04',2,481.00,1,744),
        ('2016-11-04',1,471.00,1,733),
        ('2011-04-21',3,752.00,1,744),
        ('2018-11-21',2,393.00,1,733),
        ('2010-08-06',3,748.00,1,744),
        ('2017-06-21',1,481.00,1,733),
        ('2017-09-24',1,755.00,1,733),
        ('2015-03-15',1,350.00,1,744),
        ('2011-04-26',1,471.00,1,744),
        ('2018-03-15',1,512.00,1,733),
        ('2010-03-20',3,300.00,1,744),
        ('2018-01-16',1,744.00,1,733),
        ('2011-04-15',3,753.00,1,744),
        ('2012-08-04',1,669.00,1,744),
        ('2013-02-03',1,430.00,1,744),
        ('2015-05-08',2,536.00,1,744),
        ('2015-07-21',2,765.00,1,744),
        ('2010-05-28',1,315.00,1,744),
        ('2016-10-06',3,389.00,1,733),
        ('2011-03-05',2,609.00,1,744),
        ('2011-01-26',3,517.00,1,744),
        ('2010-12-05',1,557.00,1,744),
        ('2016-03-02',2,306.00,1,733),
        ('2013-01-25',1,442.00,1,744),
        ('2010-01-15',3,598.00,1,744),
        ('2015-12-09',3,572.00,1,744),
        ('2013-12-22',3,757.00,1,744),
        ('2019-06-22',1,578.00,1,733),
        ('2015-10-18',1,418.00,1,744),
        ('2013-07-27',3,332.00,1,744),
        ('2013-02-21',3,667.00,1,744),
        ('2017-10-15',3,458.00,1,733),
        ('2012-03-08',3,355.00,1,744),
        ('2015-08-04',1,382.00,1,744),
        ('2015-04-20',2,384.00,1,744),
        ('2012-05-19',2,782.00,1,744),
        ('2012-04-24',1,623.00,1,744),
        ('2010-01-19',2,752.00,1,744),
        ('2012-06-04',2,346.00,1,744),
        ('2014-03-07',1,634.00,1,744),
        ('2014-04-12',2,744.00,1,744),
        ('2019-04-11',1,461.00,1,733),
        ('2017-03-15',2,367.00,1,733),
        ('2011-02-20',1,554.00,1,744),
        ('2017-11-21',3,796.00,1,733),
        ('2011-04-27',2,555.00,1,744),
        ('2017-05-05',1,341.00,1,733),
        ('2011-11-15',3,764.00,1,744),
        ('2011-07-14',3,312.00,1,744),
        ('2018-12-23',2,704.00,1,733),
        ('2017-05-09',2,785.00,1,733),
        ('2013-05-15',1,496.00,1,744),
        ('2011-12-08',1,726.00,1,744),
        ('2017-07-10',1,546.00,1,733),
        ('2013-06-13',3,500.00,1,744),
        ('2012-03-18',1,385.00,1,744),
        ('2015-05-28',3,765.00,1,744),
        ('2012-07-20',1,720.00,1,744),
        ('2016-02-26',1,476.00,1,733),
        ('2019-02-26',3,772.00,1,733),
        ('2013-04-13',1,758.00,1,744),
        ('2014-05-11',2,747.00,1,744),
        ('2011-11-23',2,417.00,1,744),
        ('2011-06-22',2,334.00,1,744),
        ('2012-11-01',1,341.00,1,744),
        ('2010-11-04',1,344.00,1,744),
        ('2018-01-20',2,538.00,1,733),
        ('2019-06-22',3,695.00,1,733),
        ('2015-04-14',3,480.00,1,744),
        ('2019-02-28',3,409.00,1,733),
        ('2018-02-09',3,477.00,1,733),
        ('2010-01-06',1,438.00,1,744),
        ('2015-02-24',3,308.00,1,744),
        ('2014-11-13',3,613.00,1,744),
        ('2017-07-18',2,584.00,1,733),
        ('2014-05-18',3,573.00,1,744),
        ('2011-06-03',1,553.00,1,744),
        ('2012-06-09',1,342.00,1,744),
        ('2010-06-08',2,700.00,1,744),
        ('2013-05-24',1,560.00,1,744),
        ('2015-01-13',1,672.00,1,744),
        ('2011-08-23',2,767.00,1,744),
        ('2011-01-26',1,335.00,1,744),
        ('2013-07-14',3,758.00,1,744),
        ('2014-05-23',2,675.00,1,744),
        ('2010-08-25',1,545.00,1,744),
        ('2012-01-20',3,526.00,1,744),
        ('2014-03-18',2,327.00,1,744),
        ('2010-10-10',2,450.00,1,744),
        ('1991-12-15',2,388.00,1,734),
        ('1991-08-03',3,396.00,1,734),
        ('1991-09-17',2,779.00,1,734),
        ('1991-10-07',1,307.00,1,734),
        ('1992-05-02',3,424.00,1,734),
        ('1992-01-10',1,443.00,1,734),
        ('1992-11-10',2,726.00,1,734),
        ('1992-12-11',2,696.00,1,734),
        ('1992-01-26',3,707.00,1,734),
        ('1993-03-13',3,494.00,1,734),
        ('1993-08-20',2,428.00,1,734),
        ('1993-03-27',2,741.00,1,734),
        ('1993-07-17',2,330.00,1,734),
        ('1993-12-02',3,738.00,1,734),
        ('1994-03-18',3,689.00,1,734),
        ('1994-12-06',1,756.00,1,734),
        ('1994-04-15',2,735.00,1,734),
        ('1994-05-01',3,471.00,1,734),
        ('1994-11-11',3,710.00,1,734),
        ('1995-02-28',3,341.00,1,734),
        ('1995-04-16',3,426.00,1,734),
        ('1995-05-22',1,427.00,1,734),
        ('1995-02-11',3,622.00,1,734),
        ('1995-04-23',3,693.00,1,734),
        ('1996-09-27',3,635.00,1,736),
        ('1996-06-26',1,414.00,1,736),
        ('1996-04-19',1,653.00,1,736),
        ('1996-03-05',2,556.00,1,736),
        ('1996-10-14',1,348.00,1,736),
        ('1997-02-09',3,566.00,1,736),
        ('1997-12-05',2,791.00,1,736),
        ('1997-08-11',3,415.00,1,736),
        ('1997-08-12',2,363.00,1,736),
        ('1997-08-17',2,733.00,1,736),
        ('1998-10-18',2,439.00,1,736),
        ('1998-03-28',3,494.00,1,736),
        ('1998-02-23',1,694.00,1,736),
        ('1998-05-09',3,632.00,1,736),
        ('1998-03-01',1,532.00,1,736),
        ('1999-06-24',1,408.00,1,736),
        ('1999-04-09',2,628.00,1,736),
        ('1999-09-21',3,772.00,1,736),
        ('1999-09-05',3,578.00,1,736),
        ('1999-04-04',3,549.00,1,736),
        ('2000-12-12',2,367.00,1,741),
        ('2000-01-08',2,353.00,1,741),
        ('2000-06-05',3,537.00,1,741),
        ('2000-05-17',1,445.00,1,741),
        ('2000-09-19',3,450.00,1,741),
        ('2001-09-09',3,537.00,1,741),
        ('2001-08-28',2,503.00,1,741),
        ('2001-05-08',3,392.00,1,741),
        ('2001-10-17',1,596.00,1,741),
        ('2001-12-11',2,695.00,1,741),
        ('2002-05-22',1,592.00,1,741),
        ('2002-02-23',3,661.00,1,741),
        ('2002-10-15',2,421.00,1,741),
        ('2002-09-05',3,524.00,1,741),
        ('2002-03-15',1,460.00,1,741),
        ('2003-04-15',1,581.00,1,741),
        ('2003-06-19',3,406.00,1,741),
        ('2003-07-19',1,791.00,1,741),
        ('2003-03-01',1,550.00,1,741),
        ('2003-12-23',3,551.00,1,741),
        ('2004-05-03',2,756.00,1,741),
        ('2004-01-02',1,347.00,1,741),
        ('2004-02-09',1,780.00,1,741),
        ('2004-03-28',1,721.00,1,741),
        ('2004-10-10',2,775.00,1,741),
        ('2005-03-11',2,483.00,1,744),
        ('2005-09-14',3,462.00,1,742),
        ('2005-03-28',3,716.00,1,742),
        ('2005-10-11',3,400.00,1,742),
        ('2005-01-19',1,563.00,1,742),
        ('2006-09-20',3,379.00,1,742),
        ('2006-12-16',2,436.00,1,744),
        ('2006-06-13',1,305.00,1,744),
        ('2006-01-24',3,628.00,1,744),
        ('2006-10-25',1,593.00,1,744),
        ('2007-11-18',3,496.00,1,744),
        ('2007-09-06',3,733.00,1,744),
        ('2007-12-17',3,601.00,1,744),
        ('2007-09-26',1,717.00,1,744),
        ('2007-12-12',1,485.00,1,744),
        ('2008-02-06',2,456.00,1,744),
        ('2008-02-13',2,465.00,1,744),
        ('2008-06-28',3,595.00,1,744),
        ('2008-07-20',1,421.00,1,744),
        ('2008-03-13',3,797.00,1,744),
        ('2009-01-24',1,492.00,1,744),
        ('2009-05-11',3,595.00,1,742),
        ('2009-08-18',2,354.00,1,742),
        ('2009-05-07',2,653.00,1,742),
        ('2009-02-04',2,598.00,1,742),
        ('2010-12-02',1,351.00,1,742),
        ('2010-09-15',1,322.00,1,744),
        ('2010-03-24',3,320.00,1,744),
        ('2010-12-06',1,331.00,1,744),
        ('2010-04-15',3,752.00,1,744),
        ('2010-04-10',3,713.00,1,744);
-- =====================================
--insert deaths
INSERT INTO "public".deaths(massid, laybrotherid, deathdate)
VALUES
 (199 ,394, '1990-01-01'),
 (180 ,297,  '1990-06-13'),
 (144 ,253,  '1991-10-02'),
 (120 ,270,   '1996-08-28'),
 (164 ,117,   '1996-01-20'),
 (117 ,259,   '1994-01-18'),
 (115 ,218,   '1998-10-24'),
 (132 ,320,   '1995-01-03'),
 (103 ,146,   '1993-11-01'),
 (179 ,135,   '1999-03-08'),
 (198 ,165,   '1995-08-09'),
 (169 ,115,   '1999-05-06'),
 (136 ,105,   '1990-05-08'),
 (187 ,313,   '1991-03-11'),
 (136 ,343,   '1993-12-04'),
 (164 ,125,   '1999-12-08'),
 (102 ,99,   '1994-05-28'),
 (196 ,162,   '1999-08-02'),
 (190 ,206,  '1992-05-13'),
 (115 ,322,   '1990-05-09'),
 (126 ,212,   '1997-04-02'),
 (198 ,178,   '1995-10-22'),
 (108 ,107,   '1992-07-19'),
 (112 ,264,   '1990-02-26'),
 (113 ,109,   '1991-05-21'),
 (136 ,335,   '1994-06-22'),
 (180 ,347,   '1993-06-18'),
 (138 ,316,   '1993-03-20'),
 (136 ,243,   '1990-08-27'),
 (198 ,321,  '1991-10-05'),
 (141 ,121,   '1995-04-19'),
 (144 ,288,   '1996-01-08'),
 (129 ,268,   '1994-12-11'),
 (147 ,273,   '1992-09-03'),
 (142 ,210,   '1990-11-17'),
 (168 ,336,   '1991-03-16'),
 (196 ,131,   '1990-07-22'),
 (154 ,379,   '1994-12-05'),
 (153 ,256,   '1999-01-24'),
 (142 ,228,   '1993-01-12'),
 (127 ,114,   '1993-03-09'),
 (167 ,372,   '1995-11-08'),
 (144 ,242,   '1999-05-01'),
 (173 ,170,   '1993-05-06'),
 (145 ,285,   '1992-09-19'),
 (121 ,237,   '1990-06-17'),
 (135 ,195,  '1991-11-18'),
 (114 ,350,  '1997-03-19');

-- =============================
--insert acolytes
INSERT INTO acolytes(
 laybrotherid, inaugurationdate, enddate)
 VALUES
  (13, '1985-04-01','2020-01-01'),
  (17, '1985-01-01','2020-01-01'),
  (2, '1988-01-01','2020-01-01'),
  (21, '1988-05-01','2020-01-01'),
  (46, '1990-01-01',NULL),
  (33, '1990-01-01',NULL),
  (32, '1988-07-01',NULL),
  (72, '1985-01-01',NULL),
  (92, '1987-01-01',NULL),
  (3, '1989-08-01',NULL),
  (4, '1989-01-01',NULL),
  (12, '1989-01-01',NULL),
  (23, '1989-08-01',NULL),
  (25, '1986-08-01',NULL),
  (49, '1986-08-01',NULL),
  (82, '1986-08-01',NULL),
  (36, '1986-01-01',NULL),
  (76, '1986-01-01',NULL),
  (90, '1987-01-01',NULL),
  (57, '1987-01-01',NULL);


-- ======================================
--insert acolytes masses


--insert acolytes masses
INSERT INTO acolytesmasses(acolyteid, massid)
VALUES
 (72, 1),
 (72, 2),
 (4, 2),
 (33, 2),
 (23, 3),
 (17, 3),
 (46, 3),
 (82, 3),
 (21, 3),
 (32, 4),
 (49, 4),
 (76, 4),
 (82, 4),
 (36, 5),
 (32, 6),
 (76, 6),
 (17, 6),
 (23, 6),
 (49, 6),
 (32, 7),
 (90, 7),
 (4, 7),
 (92, 7),
 (21, 7),
 (32, 8),
 (72, 8),
 (33, 8),
 (17, 8),
 (23, 9),
 (3, 9),
 (57, 9),
 (2, 10),
 (49, 11),
 (57, 11),
 (57, 12),
 (4, 12),
 (3, 13),
 (23, 13),
 (33, 13),
 (32, 14),
 (36, 14),
 (3, 15),
 (12, 16),
 (25, 16),
 (49, 16),
 (72, 16),
 (12, 17),
 (76, 17),
 (57, 18),
 (76, 19),
 (23, 19),
 (82, 19),
 (17, 19),
 (2, 20),
 (17, 20),
 (32, 20),
 (12, 20),
 (57, 20),
 (36, 21),
 (82, 21),
 (33, 22),
 (72, 23),
 (21, 23),
 (2, 24),
 (17, 24),
 (25, 24),
 (82, 24),
 (4, 25),
 (2, 25),
 (32, 25),
 (46, 26),
 (21, 26),
 (4, 27),
 (23, 27),
 (32, 27),
 (3, 27),
 (33, 28),
 (2, 28),
 (82, 28),
 (3, 28),
 (36, 29),
 (21, 29),
 (82, 30),
 (23, 30),
 (25, 30),
 (2, 30),
 (57, 31),
 (23, 32),
 (23, 32),
 (3, 32),
 (32, 32),
 (76, 32),
 (82, 33),
 (25, 33),
 (57, 33),
 (21, 34),
 (32, 34),
 (46, 34),
 (92, 34),
 (33, 35),
 (92, 35),
 (72, 35),
 (57, 36),
 (12, 36),
 (2, 37),
 (72, 37),
 (25, 37),
 (33, 37),
 (32, 37),
 (92, 38),
 (23, 38),
 (17, 38),
 (21, 38),
 (90, 39),
 (72, 39),
 (90, 40),
 (57, 40),
 (82, 40),
 (76, 40),
 (72, 40),
 (4, 41),
 (3, 42),
 (12, 42),
 (72, 43),
 (23, 43),
 (21, 44),
 (2, 44),
 (25, 44),
 (25, 45),
 (12, 46),
 (36, 46),
 (32, 47),
 (4, 47),
 (32, 48),
 (82, 49),
 (23, 49),
 (72, 50),
 (46, 50),
 (4, 50);
-- =========================================
--insert priest masses
INSERT INTO priestsmasses 
VALUES
 (742,350),
 (744,375),
 (744,382),
 (741,358),
 (740,355),
 (744,362),
 (742,386),
 (742,389),
 (741,378),
 (743,357),
 (742,393),
 (741,390),
 (742,355),
 (740,376),
 (741,373),
 (741,346),
 (741,387),
 (742,370),
 (740,356),
 (743,375),
 (744,375),
 (742,394),
 (744,355),
 (743,357),
 (744,383),
 (744,387),
 (744,367),
 (741,365),
 (743,385),
 (741,351),
 (741,347),
 (743,393),
 (741,348),
 (743,351),
 (744,381),
 (741,379),
 (740,351),
 (742,385),
 (740,377),
 (744,350),
 (742,388),
 (741,358),
 (744,377),
 (740,377),
 (742,375),
 (740,347),
 (741,371),
 (742,385),
 (740,378),
 (741,346),
 (740,350),
 (743,358),
 (743,362),
 (741,382),
 (741,353),
 (743,384),
 (744,350),
 (743,346),
 (741,347),
 (742,383),
 (741,348),
 (740,386),
 (744,366),
 (742,352),
 (741,358),
 (744,389),
 (744,393),
 (741,347),
 (740,377),
 (742,376),
 (741,351),
 (740,367),
 (740,350),
 (744,351),
 (742,383),
 (743,384),
 (740,386),
 (741,370),
 (744,351),
 (744,395),
 (741,369),
 (740,378),
 (742,362),
 (743,357),
 (740,391),
 (740,385),
 (742,386),
 (740,345),
 (743,375),
 (744,375),
 (744,357),
 (742,382),
 (744,379),
 (740,382),
 (740,389),
 (741,382),
 (742,362),
 (741,375),
 (740,393);
-- ======================================
--insert meeting types
INSERT INTO meetingtypes(meetingtype)
 VALUES
 ('Grill'),
 ('Rosary'),
 ('Retreat'),
 ('Football tournament'),
 ('Psalm singing workshops');
-- ======================================
--insert acolyte meetings
INSERT INTO acolytemeetings(meetingdate, meetingtype, meetingcost)
 VALUES
  ( '2011-01-19', 3, 120),
  ( '2010-03-9', 1, 223787),
  ( '2013-12-5', 4, 345),
  ( '2014-11-9', 2, 4626),
  ( '2005-11-3', 5, 57463),
  ( '2010-11-13', 2, 6844),
  ( '2007-02-7', 4, 7488),
  ( '2004-05-2', 3, 83456),
  ( '2002-06-9', 3, 9345),
  ( '2010-04-19', 1, 1022),
  ( '2010-11-9', 4, 4576),
  ( '2003-12-29', 1, 545),
  ( '2010-05-4', 5, 0),
  ( '2001-01-9', 1, 23423),
  ( '2000-03-28', 2, 0),
  ( '2009-10-9', 1, 232),
  ( '2004-04-1', 2, 4533),
  ( '2003-03-13', 3, 6547),
  ( '2009-01-4', 5, 454),
  ( '2006-03-16', 1, 56443);
-- =====================================
--insert acolyte on  meetings
INSERT INTO acolytesonmeetings(
 acolyteid, meetingid)
 VALUES
(3,10),
(3,5),
(4,1),
(57,15),
(36,7),
(57,8),
(90,14),
(76,13),
(49,8),
(90,2),
(57,2),
(13,18),
(76,3),
(76,8),
(36,9),
(36,8),
(49,1),
(76,15),
(76,5),
(82,7),
(76,7),
(57,2),
(57,11),
(36,7),
(49,6),
(76,7),
(49,12),
(90,13),
(82,14),
(76,20),
(3,17),
(57,6),
(49,7),
(36,19),
(90,19),
(82,14),
(57,11),
(57,3),
(90,20),
(4,9),
(36,2),
(36,20),
(82,2),
(3,15),
(36,14),
(36,4),
(82,16),
(3,9),
(36,6),
(57,17),
(57,18),
(36,11),
(49,13),
(76,20),
(76,16),
(49,13),
(4,14),
(49,2),
(13,17),
(13,18),
(3,18),
(90,2),
(76,5),
(57,12),
(90,2),
(36,5),
(13,10),
(76,15),
(4,19),
(49,9),
(49,14),
(82,14),
(82,4),
(76,20),
(4,12),
(3,18),
(90,8),
(13,12),
(13,13),
(3,9),
(76,7),
(36,2),
(36,11),
(76,11),
(90,8),
(82,19),
(4,8),
(49,6),
(3,8),
(76,20),
(90,2),
(82,5),
(57,6),
(76,17),
(36,20),
(3,2),
(90,12);
--======================================

--insert marriages
INSERT INTO marriages(wifeid,husbandid,massid,wifebestpersonid,husbandbestpersonid) VALUES
  ( 302, 102, 101,  314, 266),
  ( 303, 104, 102,  173, 237),
  ( 305, 105, 103,  173, 389),
  ( 307, 108, 104,  276, 242),
  ( 310, 110, 105,  152, 168),
  ( 311, 112, 106,  247, 360),
  ( 313, 113, 107,  215, 178),
  ( 316, 116, 108,  170, 114),
  ( 318, 117, 109,  386, 331),
  ( 319, 120, 110,  293, 255),
  ( 321, 121, 111,  214, 307),
  ( 324, 123, 112,  321, 207),
  ( 326, 126, 113,  201, 137),
  ( 328, 127, 114,  321, 220),
  ( 329, 129, 115,  124, 264),
  ( 331, 132, 116,  260, 337),
  ( 333, 134, 117,  129, 384),
  ( 336, 135, 118,  173, 253),
  ( 337, 137, 119,  373, 101),
  ( 340, 139, 120,  146, 176),
  ( 342, 142, 121,  168, 293),
  ( 343, 144, 122,  135, 334),
  ( 346, 146, 123,  370, 205),
  ( 347, 148, 124,  348, 107),
  ( 350, 150, 125,  187, 291),
  ( 352, 152, 126,  262, 353),
  ( 353, 153, 127,  197, 182),
  ( 355, 155, 128,  210, 297),
  ( 358, 158, 129,  270, 131),
  ( 360, 159, 130,  169, 294),
  ( 362, 161, 131,  346, 380),
  ( 363, 163, 132,  282, 126),
  ( 366, 165, 133,  364, 107),
  ( 368, 168, 134,  331, 388),
  ( 370, 169, 135,  107, 376),
  ( 372, 171, 136,  163, 226),
  ( 374, 174, 137,  268, 198),
  ( 375, 175, 138,  160, 237),
  ( 377, 177, 139,  354, 158),
  ( 379, 179, 140,  244, 192),
  ( 381, 181, 141,  101, 157),
  ( 383, 183, 142,  143, 197),
  ( 385, 185, 143,  290, 304),
  ( 387, 188, 144,  146, 159),
  ( 389, 190, 145,  386, 214),
  ( 391, 192, 146,  352, 331),
  ( 394, 193, 147,  194, 286),
  ( 395, 196, 148,  109, 208),
  ( 398, 197, 149,  292, 339),
  ( 400, 200, 150,  195, 298),
  ( 401, 202, 151,  314, 258),
  ( 404, 203, 152,  175, 182),
  ( 405, 206, 153,  107, 234),
  ( 408, 207, 154,  370, 360),
  ( 410, 210, 155,  344, 265),
  ( 412, 211, 156,  203, 344),
  ( 414, 213, 157,  321, 245),
  ( 416, 215, 158,  192, 262),
  ( 418, 218, 159,  200, 237),
  ( 420, 220, 160,  321, 186),
  ( 422, 222, 161,  102, 324),
  ( 423, 224, 162,  116, 247),
  ( 426, 225, 163,  209, 124),
  ( 427, 228, 164,  354, 400),
  ( 430, 230, 165,  362, 201),
  ( 431, 232, 166,  349, 328),
  ( 433, 234, 167,  110, 124),
  ( 436, 235, 168,  109, 116),
  ( 438, 238, 169,  309, 130),
  ( 440, 240, 170,  127, 304),
  ( 441, 241, 171,  295, 229),
  ( 444, 244, 172,  299, 267),
  ( 446, 246, 173,  125, 391),
  ( 447, 248, 174,  129, 224),
  ( 449, 250, 175,  279, 101),
  ( 452, 251, 176,  309, 281),
  ( 453, 253, 177,  324, 377),
  ( 456, 255, 178,  127, 133),
  ( 458, 258, 179,  152, 132),
  ( 459, 260, 180,  184, 166),
  ( 461, 261, 181,  232, 133),
  ( 463, 264, 182,  393, 293),
  ( 466, 265, 183,  208, 153),
  ( 468, 267, 184,  308, 116),
  ( 470, 270, 185,  182, 386),
  ( 472, 272, 186,  320, 128),
  ( 474, 273, 187,  266, 218),
  ( 475, 275, 188,  347, 342),
  ( 477, 278, 189,  260, 127),
  ( 480, 279, 190,  166, 139),
  ( 481, 282, 191,  127, 126),
  ( 483, 284, 192,  319, 350),
  ( 485, 285, 193,  154, 397),
  ( 488, 288, 194,  134, 206),
  ( 490, 289, 195,  128, 218),
  ( 491, 291, 196,  271, 312),
  ( 494, 293, 197,  250, 315),
  ( 495, 296, 198,  204, 357),
  ( 497, 297, 199,  367, 164),
  ( 500, 299, 200, NULL,NULL);
--====================================
--insert initialization sacraments types
INSERT INTO initializationsacramentstypes(sacramenttype)
 VALUES
 ( 'baptism'),
 ( 'Eucharist'),
 ( 'confirmation');
--=========================================
--insert apostates
INSERT INTO apostates(laybrotherid,apostasydate,valid) VALUES
 (714, '2020-01-11',true),
 (711, '2020-04-05',true);
--=============================================
--insert excommunicated
INSERT INTO excommunicated(laybrotherid,excommuniondate ) VALUES
 (710, '2020-03-18'),
 (713, '2020-02-25');
--=============================================================
--insert initiaization sacraments
INSERT INTO initializationsacraments(massid, laybrotherid, sacramenttype)
 VALUES
 ( 321, 1, 1),
  ( 343, 1, 2),
  ( 320, 2, 1),
  ( 341, 2, 2),
  ( 356, 2, 3),
  ( 320, 3, 1),
  ( 344, 3, 2),
  ( 317, 6, 1),
  ( 340, 6, 2),
  ( 320, 8, 1),
  ( 340, 8, 2),
  ( 323, 9, 1),
  ( 340, 9, 2),
  ( 324, 10, 1),
  ( 341, 10, 2),
  ( 320, 11, 1),
  ( 344, 11, 2),
  ( 320, 12, 1),
  ( 319, 14, 1),
  ( 320, 15, 1),
  ( 321, 17, 1),
  ( 342, 17, 2),
  ( 324, 18, 1),
  ( 341, 18, 2),
  ( 356, 18, 3),
  ( 320, 20, 1),
  ( 323, 21, 1),
  ( 337, 21, 2),
  ( 359, 21, 3),
  ( 320, 22, 1),
  ( 344, 22, 2),
  ( 321, 24, 1),
  ( 341, 24, 2),
  ( 324, 25, 1),
  ( 342, 25, 2),
  ( 362, 25, 3),
  ( 323, 26, 1),
  ( 342, 26, 2),
  ( 358, 26, 3),
  ( 316, 27, 1),
  ( 340, 27, 2),
  ( 360, 27, 3),
  ( 319, 28, 1),
  ( 340, 28, 2),
  ( 360, 28, 3),
  ( 318, 29, 1),
  ( 320, 31, 1),
  ( 343, 31, 2),
  ( 359, 31, 3),
  ( 319, 33, 1),
  ( 318, 34, 1),
  ( 344, 34, 2),
  ( 361, 34, 3),
  ( 318, 35, 1),
  ( 344, 35, 2),
  ( 319, 36, 1),
  ( 343, 36, 2),
  ( 323, 37, 1),
  ( 319, 38, 1),
  ( 340, 38, 2),
  ( 320, 40, 1),
  ( 336, 40, 2),
  ( 316, 41, 1),
  ( 317, 42, 1),
  ( 321, 43, 1),
  ( 320, 44, 1),
  ( 337, 44, 2),
  ( 356, 44, 3),
  ( 322, 45, 1),
  ( 337, 45, 2),
  ( 317, 46, 1),
  ( 342, 46, 2),
  ( 361, 46, 3),
  ( 319, 47, 1),
  ( 317, 48, 1),
  ( 339, 48, 2),
  ( 363, 48, 3),
  ( 324, 49, 1),
  ( 337, 49, 2),
  ( 319, 50, 1),
  ( 316, 51, 1),
  ( 341, 51, 2),
  ( 359, 51, 3),
  ( 322, 52, 1),
  ( 343, 52, 2),
  ( 356, 52, 3),
  ( 322, 53, 1),
  ( 337, 53, 2),
  ( 364, 53, 3),
  ( 317, 54, 1),
  ( 324, 55, 1),
  ( 340, 55, 2),
  ( 359, 55, 3),
  ( 324, 56, 1),
  ( 344, 56, 2),
  ( 320, 57, 1),
  ( 340, 57, 2),
  ( 318, 59, 1),
  ( 317, 60, 1),
  ( 338, 60, 2),
  ( 318, 63, 1),
  ( 340, 63, 2),
  ( 317, 64, 1),
  ( 344, 64, 2),
  ( 364, 64, 3),
  ( 318, 65, 1),
  ( 319, 66, 1),
  ( 336, 66, 2),
  ( 317, 68, 1),
  ( 342, 68, 2),
  ( 320, 69, 1),
  ( 340, 69, 2),
  ( 361, 69, 3),
  ( 317, 70, 1),
  ( 317, 71, 1),
  ( 343, 71, 2),
  ( 360, 71, 3),
  ( 324, 73, 1),
  ( 336, 73, 2),
  ( 319, 76, 1),
  ( 320, 78, 1),
  ( 340, 78, 2),
  ( 319, 80, 1),
  ( 341, 80, 2),
  ( 363, 80, 3),
  ( 318, 81, 1),
  ( 340, 81, 2),
  ( 317, 82, 1),
  ( 338, 82, 2),
  ( 322, 83, 1),
  ( 342, 83, 2),
  ( 318, 84, 1),
  ( 339, 84, 2),
  ( 320, 85, 1),
  ( 324, 86, 1),
  ( 322, 87, 1),
  ( 336, 87, 2),
  ( 357, 87, 3),
  ( 317, 88, 1),
  ( 322, 89, 1),
  ( 319, 90, 1),
  ( 344, 90, 2),
  ( 318, 91, 1),
  ( 342, 91, 2),
  ( 321, 93, 1),
  ( 318, 94, 1),
  ( 344, 94, 2),
  ( 319, 98, 1),
  ( 324, 100, 1),
  ( 324, 101, 1),
  ( 319, 102, 1),
  ( 317, 103, 1),
  ( 336, 103, 2),
  ( 357, 103, 3),
  ( 321, 104, 1),
  ( 342, 104, 2),
  ( 324, 106, 1),
  ( 342, 106, 2),
  ( 324, 107, 1),
  ( 340, 107, 2),
  ( 363, 107, 3),
  ( 317, 109, 1),
  ( 323, 110, 1),
  ( 343, 110, 2),
  ( 323, 112, 1),
  ( 322, 114, 1),
  ( 322, 115, 1),
  ( 340, 115, 2),
  ( 356, 115, 3),
  ( 323, 116, 1),
  ( 341, 116, 2),
  ( 357, 116, 3),
  ( 320, 117, 1),
  ( 322, 119, 1),
  ( 336, 119, 2),
  ( 321, 121, 1),
  ( 343, 121, 2),
  ( 362, 121, 3),
  ( 316, 122, 1),
  ( 341, 122, 2),
  ( 323, 123, 1),
  ( 344, 123, 2),
  ( 324, 124, 1),
  ( 342, 124, 2),
  ( 362, 124, 3),
  ( 320, 126, 1),
  ( 337, 126, 2),
  ( 323, 127, 1),
  ( 342, 127, 2),
  ( 318, 128, 1),
  ( 323, 129, 1),
  ( 339, 129, 2),
  ( 324, 130, 1),
  ( 337, 130, 2),
  ( 356, 130, 3),
  ( 322, 131, 1),
  ( 344, 131, 2),
  ( 318, 132, 1),
  ( 341, 132, 2),
  ( 318, 134, 1),
  ( 338, 134, 2),
  ( 324, 135, 1),
  ( 320, 136, 1),
  ( 344, 136, 2),
  ( 319, 137, 1),
  ( 323, 138, 1),
  ( 340, 138, 2),
  ( 322, 139, 1),
  ( 316, 141, 1),
  ( 338, 141, 2),
  ( 363, 141, 3),
  ( 322, 143, 1),
  ( 341, 143, 2),
  ( 320, 144, 1),
  ( 318, 145, 1),
  ( 339, 145, 2),
  ( 324, 146, 1),
  ( 337, 146, 2),
  ( 317, 147, 1),
  ( 338, 147, 2),
  ( 358, 147, 3),
  ( 320, 148, 1),
  ( 342, 148, 2),
  ( 324, 149, 1),
  ( 316, 150, 1),
  ( 340, 150, 2),
  ( 358, 150, 3),
  ( 324, 151, 1),
  ( 320, 152, 1),
  ( 338, 152, 2),
  ( 364, 152, 3),
  ( 320, 155, 1),
  ( 341, 155, 2),
  ( 324, 157, 1),
  ( 343, 157, 2),
  ( 361, 157, 3),
  ( 320, 158, 1),
  ( 323, 159, 1),
  ( 340, 159, 2),
  ( 362, 159, 3),
  ( 320, 160, 1),
  ( 340, 160, 2),
  ( 317, 162, 1),
  ( 344, 162, 2),
  ( 317, 164, 1),
  ( 316, 165, 1),
  ( 320, 166, 1),
  ( 341, 166, 2),
  ( 356, 166, 3),
  ( 321, 167, 1),
  ( 336, 167, 2),
  ( 358, 167, 3),
  ( 318, 168, 1),
  ( 339, 168, 2),
  ( 320, 172, 1),
  ( 341, 172, 2),
  ( 358, 172, 3),
  ( 316, 173, 1),
  ( 344, 173, 2),
  ( 324, 174, 1),
  ( 340, 174, 2),
  ( 320, 175, 1),
  ( 340, 175, 2),
  ( 320, 176, 1),
  ( 343, 176, 2),
  ( 321, 177, 1),
  ( 341, 177, 2),
  ( 356, 177, 3),
  ( 320, 179, 1),
  ( 338, 179, 2),
  ( 358, 179, 3),
  ( 317, 180, 1),
  ( 317, 181, 1),
  ( 344, 181, 2),
  ( 320, 182, 1),
  ( 319, 183, 1),
  ( 318, 184, 1),
  ( 322, 186, 1),
  ( 316, 187, 1),
  ( 340, 187, 2),
  ( 356, 187, 3),
  ( 320, 189, 1),
  ( 323, 190, 1),
  ( 340, 190, 2),
  ( 356, 190, 3),
  ( 324, 191, 1),
  ( 316, 192, 1),
  ( 339, 192, 2),
  ( 360, 192, 3),
  ( 323, 193, 1),
  ( 343, 193, 2),
  ( 316, 194, 1),
  ( 343, 194, 2),
  ( 318, 195, 1),
  ( 342, 195, 2),
  ( 358, 195, 3),
  ( 319, 196, 1),
  ( 324, 198, 1),
  ( 341, 198, 2),
  ( 323, 199, 1),
  ( 322, 200, 1),
  ( 340, 200, 2),
  ( 320, 202, 1),
  ( 340, 202, 2),
  ( 320, 203, 1),
  ( 343, 203, 2),
  ( 364, 203, 3),
  ( 322, 204, 1),
  ( 342, 204, 2),
  ( 324, 205, 1),
  ( 339, 205, 2),
  ( 360, 205, 3),
  ( 316, 206, 1),
  ( 340, 206, 2),
  ( 324, 208, 1),
  ( 344, 208, 2),
  ( 361, 208, 3),
  ( 319, 209, 1),
  ( 321, 210, 1),
  ( 337, 210, 2),
  ( 318, 211, 1),
  ( 339, 211, 2),
  ( 360, 211, 3),
  ( 324, 212, 1),
  ( 336, 212, 2),
  ( 319, 213, 1),
  ( 340, 213, 2),
  ( 318, 218, 1),
  ( 336, 218, 2),
  ( 359, 218, 3),
  ( 324, 219, 1),
  ( 320, 223, 1),
  ( 317, 224, 1),
  ( 321, 225, 1),
  ( 338, 225, 2),
  ( 316, 226, 1),
  ( 336, 226, 2),
  ( 360, 226, 3),
  ( 323, 227, 1),
  ( 340, 227, 2),
  ( 357, 227, 3),
  ( 317, 228, 1),
  ( 341, 228, 2),
  ( 358, 228, 3),
  ( 319, 229, 1),
  ( 317, 230, 1),
  ( 323, 231, 1),
  ( 320, 232, 1),
  ( 340, 232, 2),
  ( 319, 233, 1),
  ( 342, 233, 2),
  ( 357, 233, 3),
  ( 323, 234, 1),
  ( 336, 234, 2),
  ( 320, 235, 1),
  ( 337, 235, 2),
  ( 356, 235, 3),
  ( 323, 236, 1),
  ( 336, 236, 2),
  ( 318, 241, 1),
  ( 317, 242, 1),
  ( 320, 243, 1),
  ( 340, 243, 2),
  ( 360, 243, 3),
  ( 324, 244, 1),
  ( 317, 245, 1),
  ( 337, 245, 2),
  ( 360, 245, 3),
  ( 317, 247, 1),
  ( 344, 247, 2),
  ( 357, 247, 3),
  ( 324, 248, 1),
  ( 318, 249, 1),
  ( 339, 249, 2),
  ( 316, 250, 1),
  ( 344, 250, 2),
  ( 360, 250, 3),
  ( 323, 251, 1),
  ( 340, 251, 2),
  ( 357, 251, 3),
  ( 320, 252, 1),
  ( 323, 253, 1),
  ( 344, 253, 2),
  ( 363, 253, 3),
  ( 324, 254, 1),
  ( 344, 254, 2),
  ( 357, 254, 3),
  ( 323, 256, 1),
  ( 322, 257, 1),
  ( 339, 257, 2),
  ( 359, 257, 3),
  ( 320, 258, 1),
  ( 341, 258, 2),
  ( 317, 259, 1),
  ( 340, 259, 2),
  ( 316, 260, 1),
  ( 343, 260, 2),
  ( 358, 260, 3),
  ( 319, 262, 1),
  ( 339, 262, 2),
  ( 356, 262, 3),
  ( 323, 263, 1),
  ( 344, 263, 2),
  ( 320, 264, 1),
  ( 340, 264, 2),
  ( 361, 264, 3),
  ( 317, 266, 1),
  ( 340, 266, 2),
  ( 363, 266, 3),
  ( 319, 267, 1),
  ( 337, 267, 2),
  ( 320, 268, 1),
  ( 317, 269, 1),
  ( 338, 269, 2),
  ( 362, 269, 3),
  ( 316, 270, 1),
  ( 340, 270, 2),
  ( 364, 270, 3),
  ( 318, 271, 1),
  ( 339, 271, 2),
  ( 361, 271, 3),
  ( 323, 272, 1),
  ( 342, 272, 2),
  ( 316, 273, 1),
  ( 317, 274, 1),
  ( 342, 274, 2),
  ( 362, 274, 3),
  ( 320, 275, 1),
  ( 322, 277, 1),
  ( 341, 277, 2),
  ( 322, 278, 1),
  ( 316, 280, 1),
  ( 336, 280, 2),
  ( 318, 281, 1),
  ( 340, 281, 2),
  ( 356, 281, 3),
  ( 323, 283, 1),
  ( 341, 283, 2),
  ( 360, 283, 3),
  ( 316, 284, 1),
  ( 319, 285, 1),
  ( 336, 285, 2),
  ( 357, 285, 3),
  ( 321, 287, 1),
  ( 340, 287, 2),
  ( 324, 288, 1),
  ( 342, 288, 2),
  ( 358, 288, 3),
  ( 323, 292, 1),
  ( 340, 292, 2),
  ( 361, 292, 3),
  ( 320, 294, 1),
  ( 323, 295, 1),
  ( 338, 295, 2),
  ( 363, 295, 3),
  ( 320, 296, 1),
  ( 343, 296, 2),
  ( 320, 297, 1),
  ( 338, 297, 2),
  ( 362, 297, 3),
  ( 323, 298, 1),
  ( 317, 299, 1),
  ( 343, 299, 2),
  ( 361, 299, 3),
  ( 316, 301, 1),
  ( 344, 301, 2),
  ( 324, 302, 1),
  ( 319, 304, 1),
  ( 321, 306, 1),
  ( 342, 306, 2),
  ( 322, 307, 1),
  ( 340, 307, 2),
  ( 358, 307, 3),
  ( 319, 308, 1),
  ( 324, 309, 1),
  ( 342, 309, 2),
  ( 317, 310, 1),
  ( 341, 310, 2),
  ( 362, 310, 3),
  ( 323, 311, 1),
  ( 319, 312, 1),
  ( 339, 312, 2),
  ( 363, 312, 3),
  ( 320, 313, 1),
  ( 320, 314, 1),
  ( 318, 315, 1),
  ( 322, 316, 1),
  ( 320, 317, 1),
  ( 342, 317, 2),
  ( 361, 317, 3),
  ( 316, 318, 1),
  ( 343, 318, 2),
  ( 359, 318, 3),
  ( 319, 319, 1),
  ( 336, 319, 2),
  ( 318, 320, 1),
  ( 321, 321, 1),
  ( 340, 321, 2),
  ( 318, 322, 1),
  ( 344, 322, 2),
  ( 360, 322, 3),
  ( 317, 324, 1),
  ( 340, 324, 2),
  ( 363, 324, 3),
  ( 324, 326, 1),
  ( 317, 327, 1),
  ( 343, 327, 2),
  ( 364, 327, 3),
  ( 318, 328, 1),
  ( 339, 328, 2),
  ( 363, 328, 3),
  ( 319, 329, 1),
  ( 343, 329, 2),
  ( 357, 329, 3),
  ( 324, 330, 1),
  ( 320, 331, 1),
  ( 343, 331, 2),
  ( 356, 331, 3),
  ( 318, 332, 1),
  ( 342, 332, 2),
  ( 319, 333, 1),
  ( 342, 333, 2),
  ( 322, 337, 1),
  ( 323, 338, 1),
  ( 317, 339, 1),
  ( 336, 339, 2),
  ( 321, 341, 1),
  ( 342, 341, 2),
  ( 316, 342, 1),
  ( 339, 342, 2),
  ( 321, 345, 1),
  ( 342, 345, 2),
  ( 322, 346, 1),
  ( 319, 349, 1),
  ( 340, 349, 2),
  ( 321, 350, 1),
  ( 323, 352, 1),
  ( 337, 352, 2),
  ( 358, 352, 3),
  ( 324, 353, 1),
  ( 318, 354, 1),
  ( 344, 354, 2),
  ( 360, 354, 3),
  ( 323, 355, 1),
  ( 340, 355, 2),
  ( 316, 356, 1),
  ( 340, 356, 2),
  ( 323, 357, 1),
  ( 340, 357, 2),
  ( 362, 357, 3),
  ( 316, 358, 1),
  ( 320, 359, 1),
  ( 338, 359, 2),
  ( 360, 359, 3),
  ( 323, 360, 1),
  ( 340, 360, 2),
  ( 324, 362, 1),
  ( 336, 362, 2),
  ( 356, 362, 3),
  ( 323, 364, 1),
  ( 341, 364, 2),
  ( 323, 367, 1),
  ( 339, 367, 2),
  ( 360, 367, 3),
  ( 319, 368, 1),
  ( 344, 368, 2),
  ( 320, 369, 1),
  ( 344, 369, 2),
  ( 359, 369, 3),
  ( 321, 371, 1),
  ( 340, 371, 2),
  ( 319, 373, 1),
  ( 340, 373, 2),
  ( 361, 373, 3),
  ( 318, 375, 1),
  ( 318, 376, 1),
  ( 320, 378, 1),
  ( 338, 378, 2),
  ( 323, 379, 1),
  ( 337, 379, 2),
  ( 316, 380, 1),
  ( 338, 380, 2),
  ( 320, 381, 1),
  ( 340, 381, 2),
  ( 357, 381, 3),
  ( 323, 383, 1),
  ( 342, 383, 2),
  ( 320, 385, 1),
  ( 340, 385, 2),
  ( 320, 386, 1),
  ( 341, 386, 2),
  ( 361, 386, 3),
  ( 317, 387, 1),
  ( 323, 388, 1),
  ( 320, 389, 1),
  ( 339, 389, 2),
  ( 362, 389, 3),
  ( 322, 391, 1),
  ( 338, 391, 2),
  ( 320, 392, 1),
  ( 341, 392, 2),
  ( 361, 392, 3),
  ( 316, 394, 1),
  ( 343, 394, 2),
  ( 318, 395, 1),
  ( 320, 396, 1),
  ( 339, 396, 2),
  ( 362, 396, 3),
  ( 321, 399, 1),
  ( 338, 399, 2),
  ( 358, 399, 3),
  ( 317, 400, 1),
  ( 339, 400, 2),
  ( 360, 400, 3),
  ( 321, 402, 1),
  ( 337, 402, 2),
  ( 317, 403, 1),
  ( 340, 403, 2),
  ( 320, 405, 1),
  ( 339, 405, 2),
  ( 323, 406, 1),
  ( 322, 408, 1),
  ( 342, 408, 2),
  ( 360, 408, 3),
  ( 318, 409, 1),
  ( 322, 410, 1),
  ( 336, 410, 2),
  ( 320, 412, 1),
  ( 344, 412, 2),
  ( 356, 412, 3),
  ( 318, 413, 1),
  ( 339, 413, 2),
  ( 323, 414, 1),
  ( 341, 414, 2),
  ( 320, 416, 1),
  ( 338, 416, 2),
  ( 316, 418, 1),
  ( 344, 418, 2),
  ( 316, 419, 1),
  ( 337, 419, 2),
  ( 356, 419, 3),
  ( 320, 421, 1),
  ( 340, 421, 2),
  ( 321, 424, 1),
  ( 337, 424, 2),
  ( 324, 425, 1),
  ( 344, 425, 2),
  ( 363, 425, 3),
  ( 318, 427, 1),
  ( 343, 427, 2),
  ( 324, 430, 1),
  ( 337, 430, 2),
  ( 362, 430, 3),
  ( 321, 431, 1),
  ( 324, 432, 1),
  ( 340, 432, 2),
  ( 360, 432, 3),
  ( 317, 434, 1),
  ( 320, 435, 1),
  ( 321, 436, 1),
  ( 339, 436, 2),
  ( 359, 436, 3),
  ( 323, 441, 1),
  ( 340, 441, 2),
  ( 320, 442, 1),
  ( 336, 442, 2),
  ( 318, 443, 1),
  ( 344, 443, 2),
  ( 322, 444, 1),
  ( 339, 444, 2),
  ( 323, 445, 1),
  ( 320, 449, 1),
  ( 337, 449, 2),
  ( 362, 449, 3),
  ( 318, 450, 1),
  ( 322, 451, 1),
  ( 323, 452, 1),
  ( 340, 452, 2),
  ( 363, 452, 3),
  ( 320, 453, 1),
  ( 343, 453, 2),
  ( 359, 453, 3),
  ( 323, 456, 1),
  ( 343, 456, 2),
  ( 359, 456, 3),
  ( 318, 457, 1),
  ( 339, 457, 2),
  ( 362, 457, 3),
  ( 322, 458, 1),
  ( 337, 458, 2),
  ( 363, 458, 3),
  ( 324, 459, 1),
  ( 338, 459, 2),
  ( 363, 459, 3),
  ( 320, 460, 1),
  ( 342, 460, 2),
  ( 356, 460, 3),
  ( 318, 461, 1),
  ( 340, 461, 2),
  ( 361, 461, 3),
  ( 317, 462, 1),
  ( 343, 462, 2),
  ( 318, 465, 1),
  ( 338, 465, 2),
  ( 358, 465, 3),
  ( 318, 467, 1),
  ( 322, 469, 1),
  ( 338, 469, 2),
  ( 363, 469, 3),
  ( 320, 470, 1),
  ( 342, 470, 2),
  ( 316, 473, 1),
  ( 340, 473, 2),
  ( 320, 474, 1),
  ( 342, 474, 2),
  ( 361, 474, 3),
  ( 317, 475, 1),
  ( 324, 476, 1),
  ( 316, 477, 1),
  ( 340, 477, 2),
  ( 318, 478, 1),
  ( 340, 478, 2),
  ( 321, 479, 1),
  ( 337, 479, 2),
  ( 359, 479, 3),
  ( 324, 480, 1),
  ( 322, 481, 1),
  ( 340, 481, 2),
  ( 357, 481, 3),
  ( 318, 482, 1),
  ( 341, 482, 2),
  ( 320, 483, 1),
  ( 340, 483, 2),
  ( 357, 483, 3),
  ( 320, 484, 1),
  ( 341, 484, 2),
  ( 362, 484, 3),
  ( 318, 485, 1),
  ( 343, 485, 2),
  ( 359, 485, 3),
  ( 322, 487, 1),
  ( 342, 487, 2),
  ( 321, 488, 1),
  ( 340, 488, 2),
  ( 316, 489, 1),
  ( 337, 489, 2),
  ( 319, 490, 1),
  ( 338, 490, 2),
  ( 323, 491, 1),
  ( 342, 491, 2),
  ( 360, 491, 3),
  ( 317, 492, 1),
  ( 343, 492, 2),
  ( 358, 492, 3),
  ( 316, 493, 1),
  ( 342, 493, 2),
  ( 361, 493, 3),
  ( 317, 494, 1),
  ( 342, 494, 2),
  ( 318, 495, 1),
  ( 342, 495, 2),
  ( 319, 497, 1);
--=============================================
--insert donations
INSERT INTO "public".donations(amount,donationdate,laybrotherid)
VALUES
 (43730207.00,'2016-06-12',13),
  (17.00,'2000-09-13',46),
  (356.00,'2013-06-05',46),
  (866.00,'2012-11-07',88),
  (348.00,'2013-03-22',84),
  (239.00,'2007-10-24',13),
  (538.00,'2001-03-01',76),
  (684.00,'2010-01-26',35),
  (251.00,'2014-01-16',10),
  (832.00,'2002-04-22',85),
  (73847988.00,'2006-04-14',93),
  (16.00,'2017-08-24',23),
  (355.00,'2005-11-02',60),
  (385.00,'2016-01-11',43),
  (685.00,'2011-06-25',57),
  (993.00,'2004-09-15',95),
  (802.00,'2018-08-01',23),
  (441.00,'2011-08-07',72),
  (563.00,'2018-08-04',62),
  (680.00,'2006-07-01',89),
  (53565926.00,'2018-02-19',92),
  (613.00,'2017-10-24',98),
  (989.00,'2016-12-12',90),
  (859.00,'2008-02-07',21),
  (572.00,'2018-02-12',10),
  (90.00,'2016-07-28',17),
  (413.00,'2001-04-03',65),
  (918.00,'2018-07-03',32),
  (307.00,'2008-05-19',76),
  (354.00,'2001-03-16',77),
  (67187291.00,'2001-01-08',62),
  (957.00,'2005-11-11',60),
  (100.00,'2001-12-12',21),
  (552.00,'2006-06-16',4),
  (263.00,'2017-05-06',64),
  (101.00,'2007-12-16',23),
  (882.00,'2005-06-04',43),
  (271.00,'2001-08-14',50),
  (210.00,'2001-10-07',11),
  (374.00,'2007-04-21',41),
  (42797096.00,'2017-08-17',20),
  (293.00,'2004-05-20',28),
  (975.00,'2003-07-01',21),
  (480.00,'2013-01-18',42),
  (53.00,'2010-06-12',54),
  (403.00,'2011-08-23',86),
  (402.00,'2012-02-28',25),
  (340.00,'2003-04-12',5),
  (436.00,'2012-05-04',70),
  (549.00,'2006-04-24',12),
  (54304616.00,'2016-10-05',8),
  (247.00,'2005-03-13',98),
  (788.00,'2013-09-04',6),
  (921.00,'2003-07-01',73),
  (808.00,'2003-07-05',66),
  (760.00,'2010-03-15',41),
  (580.00,'2008-08-23',81),
  (887.00,'2008-01-25',65),
  (980.00,'2010-12-14',71),
  (900.00,'2016-02-15',71),
  (70874427.00,'2000-05-22',5),
  (892.00,'2006-03-16',77),
  (405.00,'2018-10-07',67),
  (637.00,'2000-10-21',60),
  (36.00,'2016-09-05',41),
  (31.00,'2007-07-12',42),
  (905.00,'2014-05-07',91),
  (656.00,'2017-07-05',91),
  (732.00,'2008-07-11',8),
  (477.00,'2012-12-21',31),
  (96174983.00,'2006-06-22',14),
  (963.00,'2017-04-09',19),
  (291.00,'2018-01-28',28),
  (900.00,'2002-02-26',65),
  (698.00,'2016-07-02',69),
  (39.00,'2017-12-07',53),
  (417.00,'2011-11-17',44),
  (153.00,'2004-03-18',30),
  (119.00,'2006-07-03',44),
  (586.00,'2006-09-04',14),
  (7348111.00,'2005-09-28',54),
  (434.00,'2012-08-19',52),
  (841.00,'2013-10-15',2),
  (409.00,'2016-10-05',81),
  (370.00,'2002-10-01',85),
  (751.00,'2008-12-06',5),
  (911.00,'2017-08-23',76),
  (645.00,'2008-12-11',64),
  (83.00,'2004-02-01',62),
  (445.00,'2004-02-15',44),
  (58786761.00,'2011-12-01',66),
  (883.00,'2010-11-28',97),
  (278.00,'2009-09-07',12),
  (204.00,'2008-09-26',13),
  (539.00,'2016-10-12',58),
  (925.00,'2004-03-14',63),
  (949.00,'2010-03-17',92),
  (754.00,'2000-05-08',19),
  (446.00,'2013-09-22',33),
  (304.00,'2008-04-20',40);

-- ==================================
