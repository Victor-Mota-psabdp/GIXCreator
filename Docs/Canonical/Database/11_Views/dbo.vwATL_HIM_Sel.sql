SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_HIM_Sel]
AS
/*
SELECT TOP 10 * FROM [vwATL_HIM_Sel] (NOLOCK)
*/
	SELECT DISTINCT 
		HOU.Num_Proc_HIM	AS [BDP Reference]
		, Ship.Apelido		AS [Shipper Name]
		, Consig.Apelido	AS [Consignee Name]
		, NTF.Apelido		AS [Notify Name]
	FROM dbo.House_Imp_Mar HOU (NOLOCK)  
	INNER JOIN	dbo.Pessoa Consig (NOLOCK)	
		ON HOU.Cd_Consig_HIM = Consig.Cd_Pes 
	INNER JOIN	dbo.Pessoa Ship (NOLOCK)	
		ON HOU.Cd_Export_HIM = Ship.Cd_Pes 
	INNER JOIN	dbo.Pessoa NTF (NOLOCK)	
		ON HOU.Cd_Import_HIM = NTF.Cd_Pes 


GO
