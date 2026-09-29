SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from produto_cliente


CREATE procedure [dbo].[spAjustaCodProduto_Sel]

@cd_pes_Grupo as varchar(10)

as
	select
		cd_proc_cliente	--,count(cd_proc_cliente) Qtd 
	from 
		produto_cliente 
	where 
		cd_cliente=@cd_pes_grupo
	group by 
		cd_proc_cliente
	HAVING
		count(cd_proc_cliente)>1



GO
