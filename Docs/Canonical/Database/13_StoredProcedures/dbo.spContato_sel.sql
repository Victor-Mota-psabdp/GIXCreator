SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[spContato_sel]
		
		@cd_pes varchar(10)

as

SELECT
	contato,Depto_Ctt,cd_int,Cd_Area_Fone,(Prefixo+'-'+Num_fone) num_fone,Ramal,compl_fone, cd_Tp_Com
FROM
	comunicacao
WHERE
	cd_pes=@cd_pes and contato is not null and Num_fone is not null

GO
