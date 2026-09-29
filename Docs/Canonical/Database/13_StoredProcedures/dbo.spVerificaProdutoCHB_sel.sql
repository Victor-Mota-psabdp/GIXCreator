SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spCodProClient_sel 'EA1115162', 'AKZO ITUPEVA SURFACE', 'AKZO NOBEL SUR 63612'
--05/06/19 - CAdu - Alterao p estar no where o cd_cliente
CREATE Procedure [dbo].[spVerificaProdutoCHB_sel] 

		@Cd_Proc_Cliente 	VarChar(30),
		@Cliente			VarChar(50)

as

	Declare @Cd_Cliente	varchar(10)

Set @Cd_Cliente = (Select Cd_Pes from Pessoa  with(nolock) where apelido = @Cliente)
Set @Cd_Cliente = (select Cd_Pes_Grupo from Pessoa_LLP where Cd_Pes = @Cd_Cliente)

Select
	PC.Cd_Proc_Cliente, CHB.Descricao_Longa
from
	Produto_Cliente	PC with(nolock)
left join Produto_CHB	CHB	with(nolock) on PC.Cd_prod = CHB.cd_prod --and PC.cd_Cliente=@Cd_Cliente
where PC.cd_Proc_Cliente = @Cd_Proc_Cliente  and PC.cd_Cliente=@Cd_Cliente






GO
