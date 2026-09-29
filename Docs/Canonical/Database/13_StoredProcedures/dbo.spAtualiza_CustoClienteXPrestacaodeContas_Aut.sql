SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAtualiza_CustoClienteXPrestacaodeContas_Aut]

as
--iniciou dia 20/4 - cadu - 
--rodei colocando a data de 30 em 30 dias
--spATL_FaturaCHBRateio_Sel

		Declare @Num_proc Varchar(16)
		Declare @cd_pedido int
		Declare @Cd_Produto int
		Declare @Cd_tp_tx Varchar(3)
		Declare @Vlr_Item_Custo decimal(10,2)
		Declare @Num_NF_Custo	Varchar(20)		
		Declare @Prestacao	char(1)
		
		Declare @Data_CC	datetime
		Declare @cd_usuario varchar(6)
		Declare @tp_oper_cc	char(1)

Declare @TAB Table
	(		
		[Num_proc]			Varchar(16),
		[cd_pedido]			int,
		[Cd_Produto]		int,
		[Cd_tp_tx]			Varchar(3),
		[Vlr_Item_Custo]	decimal(10,2),
		[Num_NF_Custo]		Varchar(20),		
		[Prestacao]			char(1),
		
		[Data_CC]			datetime,
		[cd_usuario]		varchar(6),
		[tp_oper_cc]		char(1)
		
	)
	
BEGIN
	insert into @TAB
		select 
			--distinct fatura_cc
			left(fatura_cc,16) Num_Proc,
			PDET.Cd_pedido,
			PDET.Cd_produto,
			FCI.CD_tp_tx TAXA_FAT,
			dbo.fBuscaPorcentagem_PedidoProdutoCusto(left(fatura_cc,16),PDET.cd_pedido,PDET.cd_produto)* abs(FCI.Vlr_PC) ValorCusto,
			NULL,
			'S' prestacao,
			GETDATE() Data_CC,
			'ATL' cd_usuario,
			'I' tp_oper_cc
	from 
		fatura_CHB_item FCI with(nolock)
		left outer join custo_cliente CC with(nolock) on left(fatura_cc,16) = CC.num_proc and FCI.CD_tp_tx = CC.CD_tp_tx
		left outer join Pedido_ship PS with(nolock) on left(fatura_cc,16) = PS.num_proc
		left outer join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
		Left Outer Join Pedido_det PDET with(nolock) on (pdet.item=ps.item or ps.item is null)and (pdet.lote=ps.lote or ps.lote is null) and  PS.cd_produto = PDet.cd_produto and PS.cd_pedido = PDet.cd_pedido 
		Join Tipo_Taxa TT with(nolock) on FCI.Cd_Tp_Tx = TT.Cd_Tp_Tx  and TT.Ref_Ctb_Tx <> 'ADT'
	where 
		fatura_cc in 
		(select Fatura_PC from Fatura_CHB where Status_PC ='E'  and Cd_Tipo = 'P' and Data_PC >getdate() - 200)
		and CC.CD_tp_tx is null and PDet.cd_pedido is not  Null and Pdet.Cd_produto is not Null
		and (Vlr_PC > 0 ) --and FCI.CD_tp_tx <> 'XBA'
		and FCI.cd_tp_tx not in ('CF1','IRR','C01','p01')		
	group by 
		Fci.fatura_cc,FCI.CD_tp_tx, FCI.Vlr_PC,PDET.Cd_pedido,PDET.Cd_produto
		
END	


Declare C_JOBs cursor for
		Select [Num_proc],[cd_pedido],[Cd_Produto],[Cd_tp_tx],[Vlr_Item_Custo],[Num_NF_Custo],
		[Prestacao],[Data_CC],[cd_usuario],[tp_oper_cc] from @TAB
	
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into  @Num_proc,@cd_pedido ,@Cd_Produto , @Cd_tp_tx,@Vlr_Item_Custo,@Num_NF_Custo
							,@Prestacao,@Data_CC, @cd_usuario,@tp_oper_cc	
	While @@FETCH_STATUS = 0
		Begin
			insert into custo_cliente
				values(@Num_proc,@cd_pedido ,@Cd_Produto,@Cd_tp_tx,@Vlr_Item_Custo,@Num_NF_Custo,@Prestacao)
				
			Insert Log_CustoCliente 
				values (@Data_CC, @cd_usuario,@tp_oper_cc,@Num_proc,@cd_pedido ,@Cd_Produto,
						@Cd_tp_tx,@Vlr_Item_Custo,@Num_NF_Custo,@Prestacao,Null,Null,Null,Null,Null)
	
							
Fetch Next From C_JOBS Into @Num_proc,@cd_pedido ,@Cd_Produto , @Cd_tp_tx,@Vlr_Item_Custo,@Num_NF_Custo
							,@Prestacao,@Data_CC, @cd_usuario,@tp_oper_cc	
		End
	
close C_JOBS
deallocate C_JOBS



GO
