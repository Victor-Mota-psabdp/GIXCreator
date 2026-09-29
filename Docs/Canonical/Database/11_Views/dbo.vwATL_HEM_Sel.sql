SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_HEM_Sel] 
AS
/*
SELECT TOP 10 * FROM [vwATL_HEM_Sel] (NOLOCK)
*/
	SELECT  DISTINCT
		HOU.Num_Proc_HEM	AS	[BDP Reference]
		,Ship.Apelido		AS	[Shipper Name]
		,Consig.Apelido		AS	[Consignee Name]
		,NTF.Apelido		AS	[Notify Name]	
	FROM House_exp_Mar HOU (NOLOCK)
	INNER JOIN Pessoa Consig (NOLOCK) 
		ON Cd_Consig_HEM = Consig.Cd_Pes
	INNER JOIN Pessoa Ship	(NOLOCK) 
		ON Cd_Export_HEM = Ship.Cd_Pes
	INNER JOIN Pessoa NTF (NOLOCK) 
		ON HOU.Cd_Notify_HEM = NTF.Cd_Pes


GO
