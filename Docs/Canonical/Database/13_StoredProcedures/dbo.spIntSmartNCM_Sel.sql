SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 10/11/2022 - 10:28 - estava dando erro na qtde por causa dos acentos
CREATE Procedure [dbo].[spIntSmartNCM_Sel]
(
	@num_Proc Varchar(16)
)

AS

	select 
		ncm,
		--left(descricao_ncm,256) descricao_ncm ,
		left([dbo].[FRemoveAcentuacao](descricao_ncm),256) descricao_ncm
	from proc_ncm with(nolock)
	Join NCM with(nolock) on NCM.id_NCM=proc_ncm.id_ncm
	where 
		num_proc=@num_Proc

Option(hash JOIN)

GO
