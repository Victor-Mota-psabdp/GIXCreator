SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spARG_GetAirCompany](
@CdCia as varchar(20) = null )
as
BEGIN
SELECT 
Cd_Cia_Aer
,UPPER(Nome_Cia_Aer)Nome_Cia_Aer
, SCAC
, Prefix
FROM
Cia_Aerea cia
WHERE(@CdCia IS NULL OR cia.Cd_Cia_Aer=@CdCia)-- cia.Cd_Cia_Aer=@CdCia--(@CdCia IS NULL OR cia.Cd_Cia_Aer=@CdCia)
END
GO
