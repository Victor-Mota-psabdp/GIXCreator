SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu - 06/04/2022 included GetDate

CREATE Procedure [dbo].[spARG_AirlineStock_InsUpd]
(
	@Type int = null
	,@CdCia varchar(20) = null
	,@Numero varchar(20) = null
	,@Num_Proc Varchar(20) = null
	,@dateCreate datetime = null
)
AS
BEGIN	
	INSERT INTO AirlineStock(Cd_Cia_Aer, Number, CreaeDate)
	VALUES(@CdCia, @Numero, getdate())	
END



/*
BEGIN	
	INSERT INTO AirlineStock(Cd_Cia_Aer, Number, CreaeDate)
	VALUES(@CdCia, @Numero, @dateCreate)
	
END
*/
GO
