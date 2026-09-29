SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pRPSRecNf_Sel] 
AS
	Select * From Base_Nota_Fiscal BNF Join Pessoa Pes on Pes.Cd_Pes = BNF.Cd_Pes 
	Left Join Endereco Ender on Ender.Cd_Pes = BNF.Cd_Pes and Cd_Tp_End = 'COM' 
	Where (Ref_Acesso = 'C'  and RPS_Data is null and Emissao >= '2008-11-01' and CdsId is not null) OR (Emissao >= '2008-09-01' and  Ref_Acesso = 'C' and CdsId is not null AND Cd_Status = 2 and SitId <> 'C')



GO
