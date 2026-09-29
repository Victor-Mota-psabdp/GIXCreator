SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgPedido_Ship_InsUpd] ON [dbo].[Pedido_Ship] 
FOR INSERT, UPDATE
AS

	Declare @cd_produto	int
	Select @cd_produto = cd_produto from inserted
	Declare @cd_pedido	int
	Select @cd_pedido = cd_pedido from inserted
	Declare @Item	varchar(6)
	Select @Item = Item from inserted
	Declare @Lote	varchar(30)
	Select @Lote = Lote from inserted
	Declare @Num_Proc	varchar(16)
	Select @Num_Proc = Num_Proc from inserted
	 	
	--select * from Tipo_Campo_Produto_Cliente
	--1	10017	B	LI Reg. Especial
	--select * from Campo_Produto_Cliente where cd_prod = @cd_produto and Id_Campo = 1
	--2	10017	B	Necessita Drawback
	--select * from Campo_Produto_Cliente where cd_prod = @cd_produto and Id_Campo = 2
	--2	10017	B	Necessita Drawback
	--select * from tipo_ocorrencia	
	--111	LI Reg. Especial
	--112	Necessita Drawback	
	
			
	Insert hist_geral
		select 
			TP.Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=TP.Num_Proc) Seq,null,
			(CASE WHEN CPC.Id_Campo = '1' THEN 111 ELSE 112 END),
			'Produto amarrado ao JOB com tipo: ' + TCPC.Descr_Campo + ',Favor verificar!' +  ' , histórico gerado por  ' + 'ATL System' ,
			getdate(),null,'ATL' Usuario,
			null,'N','U',null
		from 
			Pedido_Ship TP with(nolock)
			join Produto_Cliente PC with(nolock) on PC.cd_prod = TP.cd_produto
			join Campo_Produto_Cliente CPC with(nolock) on CPC.cd_prod = PC.cd_prod
			join Tipo_Campo_Produto_Cliente  TCPC with(nolock) on TCPC.Id_Campo = CPC.Id_Campo
		where
			Num_Proc = @Num_Proc and PC.cd_prod = @cd_produto
			and cd_pedido = @cd_pedido and Item=@Item and Lote= @Lote
			and CPC.Id_Campo in (1,2) and CPC.Campo_Dados = '1'

GO
ALTER TABLE [dbo].[Pedido_Ship] ENABLE TRIGGER [TrgPedido_Ship_InsUpd]
GO
