SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu/erbson alterada a stored para ao ter erros nos centavos
CREATE procedure [dbo].[spATL_FaturaCHBRateio_Automatico]
--	@Fatura varchar(17),
--	@cd_usuario varchar(6)
--)
As
		Declare @cd_usuario varchar(6)
		Declare @Num_proc Varchar(16)
		Declare @cd_pedido int
		Declare @Cd_Produto int
		Declare @Cd_tp_tx Varchar(3)
		Declare @Vlr_Item_Custo decimal(10,2)
		Declare @Num_NF_Custo	Varchar(20)		
		Declare @Prestacao	char(1)
		
		Declare @Data_CC	datetime		
		Declare @tp_oper_cc	char(1)


		set @cd_usuario = 'ATL'
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
		[tp_oper_cc]		char(1),
		[Vlr_Item_Tx]		decimal(10,2)
		
	)
	
BEGIN
	insert into @TAB
		select 
			left(fatura_cc,16) Num_Proc,
			PDET.Cd_pedido,
			PDET.Cd_produto,
			FCI.CD_tp_tx TAXA_FAT,
			dbo.fBuscaPorcentagem_PedidoProdutoCusto(left(fatura_cc,16),PDET.cd_pedido,PDET.cd_produto)* abs(FCI.Vlr_PC) ValorCusto,
			NULL,
			'S' prestacao,
			GETDATE(),
			@cd_usuario,			
			'I',
			FCI.Vlr_PC
	from 
		fatura_CHB_item FCI with(nolock)
		left outer join custo_cliente CC with(nolock) on left(fatura_cc,16) = CC.num_proc and FCI.CD_tp_tx = CC.CD_tp_tx
		left outer join Pedido_ship PS with(nolock) on left(fatura_cc,16) = PS.num_proc
		left outer join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
		Left Outer Join Pedido_det PDET with(nolock) on (pdet.item=ps.item or ps.item is null)and (pdet.lote=ps.lote or ps.lote is null) and  PS.cd_produto = PDet.cd_produto and PS.cd_pedido = PDet.cd_pedido 
		Join Tipo_Taxa TT with(nolock) on FCI.Cd_Tp_Tx = TT.Cd_Tp_Tx  and TT.Ref_Ctb_Tx <> 'ADT'
	where 
		--fatura_cc  = @Fatura
		fatura_cc in (select Fatura_PC from Fatura_CHB with(nolock) where Status_PC = 'E' and cd_tipo = 'P' and Data_PC > GETDATE() -120)
		and CC.CD_tp_tx is null and PDet.cd_pedido is not  Null and Pdet.Cd_produto is not Null
		and (Vlr_PC > 0 ) and  (PS.qty >0) --and FCI.CD_tp_tx <> 'XBA'
		and FCI.cd_tp_tx not in ('CF1','IRR','C01','p01')		
	group by 
		Fci.fatura_cc,FCI.CD_tp_tx, FCI.Vlr_PC,PDET.Cd_pedido,PDET.Cd_produto
		
END	

Declare  @TAB_Tx Table (
	[Cd_tp_tx]			Varchar(3),
	[Vlr_Item_SALDO]	decimal(10,2),
	[Cd_Produto]		int
	)
insert @TAB_Tx
select cd_tp_tx,SUM(Vlr_Item_Custo)-[Vlr_Item_Tx] SALDO, MAX(Cd_Produto) Cd_Produto from  @TAB T
group by cd_tp_tx,[Vlr_Item_Tx]


update T set T.Vlr_Item_Custo = Vlr_Item_Custo - Vlr_Item_SALDO from  @TAB T
join @TAB_Tx TT on T.Cd_tp_tx = TT.Cd_tp_tx and T.Cd_Produto = TT.Cd_Produto
where Vlr_Item_SALDO <> 0

Declare C_JOBs cursor for
		Select [Num_proc],[cd_pedido],[Cd_Produto],[Cd_tp_tx],[Vlr_Item_Custo],[Num_NF_Custo],
		[Prestacao],[Data_CC],[cd_usuario],[tp_oper_cc] from @TAB where  Vlr_Item_Custo <> 0
	
		
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
