# Analisi dei clienti di una banca

## Descrizione e obiettivo del progetto

Questo progetto è stato sviluppato durante il Master in Data Science di ProfessionAI. L'azienda fittizia Banking Intelligence vuole sviluppare un modello di machine learning supervisionato per prevedere i comportamenti futuri dei propri clienti, basandosi sui dati transazionali e sulle caratteristiche del possesso di prodotti. Lo scopo del progetto è quindi creare, utilizzando il linguaggio **SQL**, una **tabella denormalizzata di feature** per il training di modelli di machine learning, arricchendo i dati dei clienti con vari indicatori calcolati a partire dalle loro transazioni e dai conti posseduti. La tabella finale sarà riferita all'ID cliente e conterrà informazioni sia di tipo quantitativo che qualitativo.

### Valore aggiunto
La tabella denormalizzata permetterà di estrarre feature comportamentali avanzate per l'addestramento di modelli di machine learning supervisionato, fornendo numerosi vantaggi per l'azienda come: predizione del comportamento dei clienti, riduzione del tasso di abbandono, miglioramento della gestione del rischio, personalizzazione delle offerte e prevenzione delle frodi.

## Struttura del database
Il database utilizzato `banca`, contenuto nel file `db_bancario.sql` presente nel repository, è costituito dalle seguenti tabelle:

1. **`Cliente`**: contiene informazioni personali sui clienti (ad esempio, età).
2. **`Conto`**: contiene informazioni sui conti posseduti dai clienti.
3. **`Tipo_conto`**: descrive le diverse tipologie di conti disponibili.
4. **`Tipo_transazione`**: contiene i tipi di transazione che possono avvenire sui conti.
5. **`Transazioni`**: contiene i dettagli delle transazioni effettuate dai clienti sui vari conti.

## Indicatori comportamentali calcolati (feature)
Gli indicatori vengono calcolati per ogni singolo cliente (riferiti a `id_cliente`) e includono:

  - **Indicatori di base**:
    - Età del cliente.
  
  - **Indicatori sulle transazioni**:
    - Numero di transazioni in uscita su tutti i conti.
    - Numero di transazioni in entrata su tutti i conti.
    - Importo totale transato in uscita su tutti i conti.
    - Importo totale transato in entrata su tutti i conti.

  - **Indicatori sui conti**:
    - Numero totale di conti posseduti.
    - Numero di conti posseduti per tipologia (un indicatore per ogni tipo di conto).

  - **Indicatori sulle transazioni per tipologia di conto**:
    - Numero di transazioni in uscita per tipologia di conto (un indicatore per tipo di conto).
    - Numero di transazioni in entrata per tipologia di conto (un indicatore per tipo di conto).
    - Importo transato in uscita per tipologia di conto (un indicatore per tipo di conto).
    - Importo transato in entrata per tipologia di conto (un indicatore per tipo di conto).

## Tabella denormalizzata
Viene creata, utilizzando una serie di join tra tabelle basandosi sull'`id_cliente` , la tabella finale denormalizzata contenente tutti gli indicatori comportamentali calcolati. Tale tabella viene poi esportata come file CSV, pronta per essere utilizzata per il training di modelli di machine learning. Essa è presente nel repository: **`tabella_finale_denormalizzata.csv`**.

## Tecnologie utilizzate
- **Linguaggio**: `SQL` – per interrogare e manipolare i dati.
- **Database Management System**: `MariaDB` (alternativa open-source a MySQL) – per gestire il database relazionale.
- **Ambiente di sviluppo**: `MySQL Workbench` – per eseguire query e gestire il database in modo grafico.
- **Server locale**: `XAMPP` – per eseguire MariaDB e Apache in locale.

## Utilizzo
1. Se non hai già un server MySQL configurato, puoi utilizzare XAMPP, che include Apache e MariaDB in un'unica soluzione. Scarica e installa XAMPP dal sito ufficiale: [https://www.apachefriends.org/index.html](https://www.apachefriends.org/index.html), avvia il pannello di controllo di XAMPP e attiva i servizi Apache e MySQL (MariaDB).
2. Aprire MySQL Workbench o un altro client SQL.
3. Scaricare, aprire ed eseguire il file `db_bancario.sql` per creare il database `banca` contenente le tabelle.
4. Scaricare, aprire ed eseguire il file `analisi_clienti_banca.sql` sul database creato. Verrà generata la tabella finale denormalizzata **tabella_feature_cliente**.
5. Esportare la tabella finale denormalizzata in CSV tramite il comando **Export** sopra la tabella.

## Autore
[Virginio Cocciaglia](https://github.com/VirginioC)
