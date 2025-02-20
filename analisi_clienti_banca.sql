/* ANALISI DEI CLIENTI DI UNA BANCA
   Master in Data Science - Profession AI
   Virginio Cocciaglia 
   
   OBIETTIVO
   L'obiettivo è creare una tabella di feature per il training di modelli di machine learning, arricchendo
   i dati dei clienti con vari indicatori calcolati a partire dalle loro transazioni e dai conti posseduti.
   La tabella finale sarà riferita all'ID cliente e conterrà informazioni sia di tipo quantitativo che qualitativo. */
   
  
/* INDICATORI DI BASE

	1. Età del cliente (da tabella cliente) */

create temporary table banca.tmp_eta as
select 
    id_cliente,
    timestampdiff(year, data_nascita, current_date) as eta
from 
	banca.cliente;


/* INDICATORI SULLE TRANSAZIONI

	2. Numero di transazioni in uscita su tutti i conti
	3. Numero di transazioni in entrata su tutti i conti
	4. Importo totale transato in uscita su tutti i conti
	5. Importo totale transato in entrata su tutti i conti */

create temporary table banca.tmp_transazioni as
select 
    cl.id_cliente,
    coalesce(sum(case when tr.importo < 0 then 1 else 0 end), 0) as numero_transazioni_uscita,
    coalesce(sum(case when tr.importo > 0 then 1 else 0 end), 0) as numero_transazioni_entrata,
    coalesce(round(sum(case when tr.importo < 0 then tr.importo else 0 end), 2), 0) as importo_uscita_totale,
    coalesce(round(sum(case when tr.importo > 0 then tr.importo else 0 end), 2), 0) as importo_entrata_totale
from 
    banca.cliente cl
left join 
    banca.conto co on cl.id_cliente = co.id_cliente
left join 
    banca.transazioni tr on co.id_conto = tr.id_conto
group by 
    cl.id_cliente;


/* INDICATORI SUI CONTI

	6. Numero totale di conti posseduti
	7. Numero di conti posseduti per tipologia (un indicatore per ogni tipo di conto) */

create temporary table banca.tmp_conti as
select 
    cl.id_cliente,
    coalesce(count(distinct co.id_conto), 0) as numero_totale_conti,
    coalesce(sum(case when co.id_tipo_conto = 0 then 1 else 0 end), 0) as numero_conti_base,
    coalesce(sum(case when co.id_tipo_conto = 1 then 1 else 0 end), 0) as numero_conti_business,
    coalesce(sum(case when co.id_tipo_conto = 2 then 1 else 0 end), 0) as numero_conti_privati,
    coalesce(sum(case when co.id_tipo_conto = 3 then 1 else 0 end), 0) as numero_conti_famiglie
from 
    banca.cliente cl
left join 
    banca.conto co on cl.id_cliente = co.id_cliente
group by 
    cl.id_cliente;
    

/* INDICATORI SULLE TRANSAZIONI PER TIPOLOGIA DI CONTO

	8. Numero di transazioni in uscita per tipologia di conto (un indicatore per tipo di conto)
	9. Numero di transazioni in entrata per tipologia di conto (un indicatore per tipo di conto)
	10. Importo transato in uscita per tipologia di conto (un indicatore per tipo di conto)
	11. Importo transato in entrata per tipologia di conto (un indicatore per tipo di conto) */

create temporary table banca.tmp_transazioni_tipo_conto as
select 
    cl.id_cliente,
    -- numero di transazioni in uscita per tipo di conto
    coalesce(sum(case when tr.importo < 0 and co.id_tipo_conto = 0 then 1 else 0 end), 0) as num_tr_uscita_conti_base,
    coalesce(sum(case when tr.importo < 0 and co.id_tipo_conto = 1 then 1 else 0 end), 0) as num_tr_uscita_conti_business,
    coalesce(sum(case when tr.importo < 0 and co.id_tipo_conto = 2 then 1 else 0 end), 0) as num_tr_uscita_conti_privati,
    coalesce(sum(case when tr.importo < 0 and co.id_tipo_conto = 3 then 1 else 0 end), 0) as num_tr_uscita_conti_famiglie,
    -- numero di transazioni in entrata per tipo di conto
    coalesce(sum(case when tr.importo > 0 and co.id_tipo_conto = 0 then 1 else 0 end), 0) as num_tr_entrata_conti_base,
    coalesce(sum(case when tr.importo > 0 and co.id_tipo_conto = 1 then 1 else 0 end), 0) as num_tr_entrata_conti_business,
    coalesce(sum(case when tr.importo > 0 and co.id_tipo_conto = 2 then 1 else 0 end), 0) as num_tr_entrata_conti_privati,
    coalesce(sum(case when tr.importo > 0 and co.id_tipo_conto = 3 then 1 else 0 end), 0) as num_tr_entrata_conti_famiglie,
    -- importo totale delle transazioni in uscita per tipo di conto
    coalesce(round(sum(case when tr.importo < 0 and co.id_tipo_conto = 0 then tr.importo else 0 end), 2), 0) as imp_uscita_tot_conti_base,
    coalesce(round(sum(case when tr.importo < 0 and co.id_tipo_conto = 1 then tr.importo else 0 end), 2), 0) as imp_uscita_tot_conti_business,
    coalesce(round(sum(case when tr.importo < 0 and co.id_tipo_conto = 2 then tr.importo else 0 end), 2), 0) as imp_uscita_tot_conti_privati,
    coalesce(round(sum(case when tr.importo < 0 and co.id_tipo_conto = 3 then tr.importo else 0 end), 2), 0) as imp_uscita_tot_conti_famiglie,
    -- importo totale delle transazioni in entrata per tipo di conto
    coalesce(round(sum(case when tr.importo > 0 and co.id_tipo_conto = 0 then tr.importo else 0 end), 2), 0) as imp_entrata_tot_conti_base,
    coalesce(round(sum(case when tr.importo > 0 and co.id_tipo_conto = 1 then tr.importo else 0 end), 2), 0) as imp_entrata_tot_conti_business,
    coalesce(round(sum(case when tr.importo > 0 and co.id_tipo_conto = 2 then tr.importo else 0 end), 2), 0) as imp_entrata_tot_conti_privati,
    coalesce(round(sum(case when tr.importo > 0 and co.id_tipo_conto = 3 then tr.importo else 0 end), 2), 0) as imp_entrata_tot_conti_famiglie
from 
    banca.cliente cl
left join 
    banca.conto co on cl.id_cliente = co.id_cliente
left join 
    banca.transazioni tr on co.id_conto = tr.id_conto
group by
    cl.id_cliente; 


/* TABELLA DENORMALIZZATA
   Si costruisce la tabella finale denormalizzata di feature, riferita all'ID cliente,
   unendo le precedenti tabelle temporanee attraverso l'utilizzo di una serie di join. */

create table banca.tabella_feature_cliente as
select 
    e.id_cliente,
    e.eta,
    t.numero_transazioni_uscita,
    t.numero_transazioni_entrata,
    t.importo_uscita_totale,
    t.importo_entrata_totale,
    c.numero_totale_conti,
    c.numero_conti_base,
    c.numero_conti_business,
    c.numero_conti_privati,
    c.numero_conti_famiglie,
    tc.num_tr_uscita_conti_base,
    tc.num_tr_uscita_conti_business,
    tc.num_tr_uscita_conti_privati,
    tc.num_tr_uscita_conti_famiglie,
    tc.num_tr_entrata_conti_base,
    tc.num_tr_entrata_conti_business,
    tc.num_tr_entrata_conti_privati,
    tc.num_tr_entrata_conti_famiglie,
    tc.imp_uscita_tot_conti_base,
    tc.imp_uscita_tot_conti_business,
    tc.imp_uscita_tot_conti_privati,
    tc.imp_uscita_tot_conti_famiglie,
    tc.imp_entrata_tot_conti_base,
    tc.imp_entrata_tot_conti_business,
    tc.imp_entrata_tot_conti_privati,
    tc.imp_entrata_tot_conti_famiglie
from 
    banca.tmp_eta e
join 
    banca.tmp_transazioni t on e.id_cliente = t.id_cliente
join 
    banca.tmp_conti c on e.id_cliente = c.id_cliente
join 
    banca.tmp_transazioni_tipo_conto tc on e.id_cliente = tc.id_cliente;
 
select * from banca.tabella_feature_cliente;