SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Produtos_CHB_Sel]
(
	@Grupo varchar(20)
)
as

Declare @Cd_Pes varchar(10)
set @Cd_Pes = (select Cd_Pes from Pessoa where Apelido = @Grupo)

select 
	Apelido [Group], 
	cd_Proc_Cliente [Product Code],
	Produto_Descr [Description] ,
	C.Descricao_Longa [CHB Product Description]
from Produto_Cliente P
	join Produto_CHB C on C.cd_prod = P.cd_prod
	join pessoa A on p.cd_Cliente = A.Cd_Pes
WHERE 
	P.cd_Cliente = @Cd_Pes
	
	/*
select 
	Apelido [Group], 
	cd_Proc_Cliente [Product Code],
	Produto_Descr [Description] ,
	P.NCM_Cliente [NCM]
	--C.Descricao_Longa [CHB Product Description]
from Produto_Cliente P
	join Produto_CHB C on C.cd_prod = P.cd_prod
	join pessoa A on p.cd_Cliente = A.Cd_Pes
WHERE 
	P.cd_Cliente = @Cd_Pes
*/
	

GO
