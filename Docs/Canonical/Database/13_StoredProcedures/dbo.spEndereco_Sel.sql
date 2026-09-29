SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     PROCEDURE [dbo].[spEndereco_Sel]

			@cd_pes varchar(10)

AS

SELECT
	Nome_Tp_end,Rua,Numero,compl_end,cep,Bairro,UF,Cidade, Pais
FROM
	endereco ED
	Join Tipo_Endereco TE on TE.cd_tp_end=ed.cd_tp_end
WHERE 
	cd_pes=@cd_pes










GO
