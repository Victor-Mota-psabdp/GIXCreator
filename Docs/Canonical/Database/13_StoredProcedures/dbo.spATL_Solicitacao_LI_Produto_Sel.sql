SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Solicitacao_LI_Produto
--sp_help Solicitacao_LI_Produto
CREATE procedure [dbo].[spATL_Solicitacao_LI_Produto_Sel]--'','','B'
(	
	@Num_Solicitacao		Varchar(13),
	@Cd_Prod_Cliente		Varchar(50),
	--@cd_produto				int,
	@Tipo					char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
--IF @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		Select			
--			convert(varchar(25),'Saved')	[Status],
--			SLP.Num_Solicitacao				[ID],
--			PC.cd_Proc_Cliente				[Product Code],
--			Produto_Descr					[Product Description],
--			NCM								[N.C.M],
--			Descricao_NCM					[N.C.M Description],
--			SLP.cd_tp_moeda					[Currency Type Code],
--			TM.Nome_Tp_moeda				[Currency Type Name],		
--			Qty								[Qty],
--			Peso_Bruto						[Gross Weight (KG)],
--			Peso_Liquido					[Net Weight (KG)],
--			Preco_Unit						[Unit Price]
--		from Solicitacao_LI_Produto SLP
--			Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
--			Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
--			Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
--		Where
--			Num_Solicitacao=@Num_Solicitacao
			
--	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select			
			convert(varchar(25),'Saved')	[Status],
			SLP.Num_Solicitacao				[ID],
			PC.cd_Proc_Cliente				[Product Code],
			Produto_Descr					[Product Description],
			NCM								[N.C.M],
			Descricao_NCM					[N.C.M Description],
			SLP.cd_tp_moeda					[Currency Type Code],
			TM.Nome_Tp_moeda				[Currency Type Name],		
			Qty								[Qty],
			Peso_Bruto						[Gross Weight (KG)],
			Peso_Liquido					[Net Weight (KG)],
			Preco_Unit						[Unit Price]
		from Solicitacao_LI_Produto SLP
			Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
			Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
			Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Where
			Num_Solicitacao=@Num_Solicitacao		
			--Num_Solicitacao=@Num_Solicitacao and slp.Cd_Produto = @cd_produto			
	End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select			
			convert(varchar(25),'Saved')	[Status],
			SLP.Num_Solicitacao				[ID],
			PC.cd_Proc_Cliente				[Product Code],
			Produto_Descr					[Product Description],
			NCM								[N.C.M],
			Descricao_NCM					[N.C.M Description],
			SLP.cd_tp_moeda					[Currency Type Code],
			TM.Nome_Tp_moeda				[Currency Type Name],		
			Qty								[Qty],
			Peso_Bruto						[Gross Weight (KG)],
			Peso_Liquido					[Net Weight (KG)],
			Preco_Unit						[Unit Price]
		from Solicitacao_LI_Produto SLP
			Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
			Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
			Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Where
			Num_Solicitacao=@Num_Solicitacao AND PC.cd_Proc_Cliente = @Cd_Prod_Cliente
			
	End

/*
ALTER procedure [dbo].[spATL_Solicitacao_LI_Produto_Sel]--'','','B'
(	
	@Num_Solicitacao		Varchar(13),
	@Cd_Prod_Cliente		Varchar(50),
	@Tipo					char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 
			--PC.cd_Proc_Cliente,
			--Produto_Descr,
			--NCM					[NCM_Code],
			--Descricao_NCM,
			--SLP.cd_tp_moeda,
			--TM.Nome_Tp_moeda,		
			--Qty	,
			--Peso_Bruto,
			--Peso_Liquido,
			--Preco_Unit
			convert(varchar(25),'Saved')	[Status],
			PC.cd_Proc_Cliente	[Codigo Produto],
			Produto_Descr		[Descricao do Produto],
			NCM					[NCM],
			Descricao_NCM		[Descrição do NCM],
			SLP.cd_tp_moeda		[Codigo da Moeda],
			TM.Nome_Tp_moeda	[Moeda],		
			Qty					[Quantidade],
			Peso_Bruto			[Peso Bruto (KG)],
			Peso_Liquido		[Peso Liquido (KG)],
			Preco_Unit			[Preço Unitário]
		from Solicitacao_LI_Produto SLP
			Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
			Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
			Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Where
			Num_Solicitacao=@Num_Solicitacao
			
	End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select 
			convert(varchar(25),'Saved')	[Status],
			PC.cd_Proc_Cliente	[Codigo Produto],
			Produto_Descr		[Descricao do Produto],
			NCM					[NCM],
			Descricao_NCM		[Descrição do NCM],
			SLP.cd_tp_moeda		[Codigo da Moeda],
			TM.Nome_Tp_moeda	[Moeda],		
			Qty					[Quantidade],
			Peso_Bruto			[Peso Bruto (KG)],
			Peso_Liquido		[Peso Liquido (KG)],
			Preco_Unit			[Preço Unitário]
		from Solicitacao_LI_Produto SLP
			Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
			Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
			Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Where
			Num_Solicitacao=@Num_Solicitacao AND PC.cd_Proc_Cliente = @Cd_Prod_Cliente
			
	End
	*/

GO
