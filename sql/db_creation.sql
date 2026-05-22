
-- Setting up environment


CREATE DATABASE military_expenditures;


USE military_expenditures;

SELECT * FROM dbo.current_spending;
SELECT * FROM dbo.per_capita;
SELECT * FROM dbo.perc_gdp;
SELECT * FROM dbo.perc_govt;
SELECT * FROM dbo.locationmaster;
SELECT * FROM dbo.unique_countries;
SELECT * FROM dbo.unique_regions;
SELECT * FROM dbo.unique_subregions;
SELECT * FROM dbo.regional_spending;
SELECT * FROM dbo.subregional_spending;


-- Adding keys/relationships



-- Lookup Tables

-- dbo.unique_countries
ALTER TABLE dbo.unique_countries
ADD CONSTRAINT pk_unique_countries_CountryID PRIMARY KEY (CountryID);


-- dbo.unique_regions
ALTER TABLE dbo.unique_regions
ADD CONSTRAINT pk_unique_regions_RegionID PRIMARY KEY (RegionID);


-- dbo.unique_subregions
ALTER TABLE dbo.unique_subregions
ADD CONSTRAINT pk_unique_subregions_SubRegionID PRIMARY KEY (SubRegionID);




-- Head table

-- dbo.locationmaster
ALTER TABLE dbo.locationmaster
ADD CONSTRAINT pk_locationmaster_CountryID PRIMARY KEY (CountryID);

ALTER TABLE dbo.locationmaster
ADD CONSTRAINT fk_locationmaster_unique_countries FOREIGN KEY (CountryID) REFERENCES dbo.unique_countries(CountryID);

ALTER TABLE dbo.locationmaster
ADD CONSTRAINT fk_locationmaster_unique_regions FOREIGN KEY (RegionID) REFERENCES dbo.unique_regions(RegionID);

ALTER TABLE dbo.locationmaster
ADD CONSTRAINT fk_locationmaster_unique_subregions FOREIGN KEY (SubRegionID) REFERENCES dbo.unique_subregions(SubRegionID);



-- Main data tables

-- dbo.current_spending
ALTER TABLE dbo.current_spending                                                                         --- Composite Primary Keys
ADD CONSTRAINT pk_current_spending_CountryID_Year PRIMARY KEY ([Year], CountryID);

ALTER TABLE dbo.current_spending
ADD CONSTRAINT fk_current_spending_locationmaster FOREIGN KEY (CountryID) REFERENCES dbo.locationmaster(CountryID);


-- dbo.per_capita
ALTER TABLE dbo.per_capita
ADD CONSTRAINT pk_per_capita_CountryID_Year PRIMARY KEY ([Year], CountryID);

ALTER TABLE dbo.per_capita
ADD CONSTRAINT fk_per_capita_locationmaster FOREIGN KEY (CountryID) REFERENCES dbo.locationmaster(CountryID);

-- dbo.perc_gdp
ALTER TABLE dbo.perc_gdp
ADD CONSTRAINT pk_perc_gdp_CountryID_Year PRIMARY KEY ([Year], CountryID);

ALTER TABLE dbo.perc_gdp
ADD CONSTRAINT fk_perc_gdp_locationmaster FOREIGN KEY (CountryID) REFERENCES dbo.locationmaster(CountryID);


-- dbo.perc_govt
ALTER TABLE dbo.perc_govt
ADD CONSTRAINT pk_perc_govt_CountryID_Year PRIMARY KEY ([Year], CountryID);

ALTER TABLE dbo.perc_govt
ADD CONSTRAINT fk_perc_govt_locationmaster FOREIGN KEY (CountryID) REFERENCES dbo.locationmaster(CountryID);


-- dbo.regional_spending
ALTER TABLE dbo.regional_spending
ADD CONSTRAINT pk_regional_spending_RegionID_Year PRIMARY KEY ([Year], RegionID);

ALTER TABLE dbo.regional_spending
ADD CONSTRAINT fk_regional_spending_unique_regions FOREIGN KEY (RegionID) REFERENCES dbo.unique_regions(RegionID);


-- dbo.subregional_spending
ALTER TABLE dbo.subregional_spending
ADD CONSTRAINT pk_subregional_spending_SubRegionID_Year PRIMARY KEY ([Year], SubRegionID);

ALTER TABLE dbo.subregional_spending
ADD CONSTRAINT fk_subregional_spending_unique_subregions FOREIGN KEY (SubRegionID) REFERENCES dbo.unique_subregions(SubRegionID);