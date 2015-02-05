create schema Project;
use Project;
create table Condition_PC(conID int,con varchar(25),primary key(conID));
create table POstcard(pcID int NOT NULL UNIQUE,Title varchar(25),ConID int,description varchar(50),
 foreign key(ConID) references Condition_PC(conID),
Primary key(Title,ConID));
create table timeera(eraID int,era varchar(25),primary key(eraID));
create table color(colID int,col varchar(25),primary key(colID));
create table thematiccategory(themID int,them varchar(25),primary key(themID));
create table pcthem(themid int,pcid int,
 foreign key(themid) references thematiccategory(themID),
foreign key(pcid) references POstcard(pcID),
primary key(themid,pcid));
create table collections(cpcid int,ccolid int,ceraid int,
foreign key(cpcid) references POstcard(pcID),
foreign key(ccolid) references color(colID),
foreign key(ceraid) references timeera(eraID),primary key(cpcid));
create table transactions(tpcid int,purchasedate date,price int,
foreign key(tpcid) references POstcard(pcID),primary key(tpcid));
select pcID,Title,description from POstcard order by pcID;
select * from POstcard;
select count(*) from POstcard;
select Title from POstcard group by Title having count(Title)=1;
select Title from POstcard group by Title having count(Title)>1;
select pc.Title,t.purchasedate,th.them from POstcard pc
                                       inner join transactions t on pc.pcID=t.tpcid 
                                       inner join pcthem pt on pc.pcID=pt.pcid 
									   inner join thematiccategory th on pt.themid=th.themID
 where t.purchasedate>1998/06/02 and th.them="people"; 
select pc.Title,e.era,th.them from POstcard pc 
									inner join collections c on pc.pcID=c.cpcid
									inner join timeera e on c.ceraid=e.eraID
									inner join pcthem pt on pc.pcID=pt.pcid
                                    inner join thematiccategory th on pt.themid=th.themID
 where e.era="golden" and th.them="people" or e.era="golden" and th.them="building";
select pc.pcID,pc.Title from POstcard pc
                                    inner join pcthem pt on pc.pcID=pt.pcid 
                                    inner join thematiccategory th on pt.themid=th.themID 
group by(pc.pcID) having count(pc.pcID)>1;
select sum(T.price),e.era from transactions T 
                                   inner join collections C on T.tpcid=C.cpcid 
                                   inner join timeera e on C.ceraid=e.eraID 
where e.era="Silver";
select avg(T.price),C.con from transactions T 
								   inner join POstcard pc on T.tpcid=pc.pcID
								   inner join Condition_PC C on pc.ConID=C.conID
 group by C.con;
select max(T.price),C.con from transactions T 
                                   inner join POstcard pc on T.tpcid=pc.pcID 
                                   inner join Condition_PC C on pc.ConID=C.conID 
where C.con!="poor";
create or replace view v1 as 
                      select Title,Con,price from POstcard,Condition_PC,transactions 
                          where POstcard.pcID=transactions.tpcid 
                               and POstcard.ConID=Condition_PC.conID;
select * from v1;
create or replace view v2 as
                       select Title,them,era from POstcard,thematiccategory,collections,timeera,pcthem where POstcard.pcid=collections.cpcid and POstcard.pcid=pcthem.pcid and pcthem.themid=thematiccategory.themID and collections.ceraid=timeera.eraID;
select * from v2;
create or replace view v3 as
					select avg(price),Title,them from transactions,POstcard,thematiccategory,pcthem 
						where transactions.tpcid=POstcard.pcID 
                        and POstcard.pcID=pcthem.pcid 
                        and pcthem.themid=thematiccategory.themID group by them,title;

select * from v3;
