SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_HIO_Sel] 
AS
/*
SELECT TOP 10 * FROM [vwATL_HIO_Sel] (NOLOCK)
*/
	SELECT DISTINCT  
		HOU.Num_Proc_HIO	AS	[BDP Reference]
		,Ship.Apelido		AS	[Shipper Name]
		,Consig.Apelido		AS	[Consignee Name]
		,NTF.Apelido		AS	[Notify Name]
	FROM House_IMP_Out HOU (NOLOCK)	
	INNER JOIN  Pessoa Consig (NOLOCK)
		ON Cd_Consig_HIO = Consig.Cd_Pes
	INNER JOIN  Pessoa Ship (NOLOCK)
		ON Cd_IMPort_HIO = Ship.Cd_Pes
	INNER JOIN  Pessoa NTF (NOLOCK)
		ON HOU.Cd_Import_HIO = NTF.Cd_Pes


GO
