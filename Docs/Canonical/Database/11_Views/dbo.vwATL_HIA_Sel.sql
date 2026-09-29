SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwATL_HIA_Sel] 
AS
/*
SELECT TOP 10 * FROM [vwATL_HIA_Sel] (NOLOCK)
*/
	SELECT DISTINCT
		HOU.Num_Proc_HIA	[BDP Reference]
		,Ship.Apelido 		[Shipper Name]
		,Consig.Apelido 		[Consignee Name]
		,NTF.Apelido			[Notify Name]
	FROM House_Imp_Aer HOU (NOLOCK)
	INNER JOIN Pessoa Consig (NOLOCK)
		ON Cd_Consig_HIA = Consig.Cd_Pes
	INNER JOIN Pessoa Ship (NOLOCK)		
		ON Cd_Export_HIA = Ship.Cd_Pes
	INNER JOIN Pessoa NTF (NOLOCK)		
		ON HOU.Cd_Import_HIA = NTF.Cd_Pes


GO
