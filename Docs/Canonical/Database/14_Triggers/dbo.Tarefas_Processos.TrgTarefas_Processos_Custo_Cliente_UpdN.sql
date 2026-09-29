SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgTarefas_Processos_Custo_Cliente_UpdN] ON [dbo].[Tarefas_Processos] 
FOR  UPDATE
AS
	Declare @Num_Proc	varchar(16)
	Declare @id_Task	Int
	Declare @Dt_Conclusao	Datetime
	Declare @Grupo Varchar(10)
	Declare @cd_usuario		varchar(6)
	
	Select @Num_Proc = Num_Proc ,@id_Task=id_task,@Dt_Conclusao=dt_conclusao,@cd_usuario=Cd_Usuario from inserted

	if @Dt_Conclusao is not null and substring(@Num_Proc,3,3) = 'CBT' and @id_Task = '63' and left(@Num_Proc,2) = 'IM'
	BEGIN
			Declare @cd_pedido		int
			Declare @Cd_Produto		int
			Declare @Cd_tp_tx		Varchar(3)
			Declare @Vlr_Item_Custo decimal(10,2)
			Declare @Num_NF_Custo	Varchar(20)		
			Declare @Prestacao		char(1)		
			Declare @Data_CC		datetime		
			Declare @tp_oper_cc		char(1)
			
		
		--Declare @Num_Proc	varchar(16)	
		--set @Num_Proc = 'IMCBT201801002BR'			
			
		Declare @TAB_Custo Table
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
			
		insert into @TAB_Custo				
				select 
					FCI.Num_Proc_Lim Num_Proc,
					PS.Cd_pedido,
					PS.Cd_produto,
					TCC.CD_tp_tx TAXA_FAT,
					(CASE when dbo.[Qty_Container] (FCI.Num_Proc_Lim) = 0 THEN 					
						abs(TCC.Vlr_Item_Custo) * 
						dbo.fBuscaPorcentagem_PedidoProdutoCusto(FCI.Num_Proc_Lim,PS.cd_pedido,PS.cd_produto) * 1 
					ELSE
						abs(TCC.Vlr_Item_Custo) * 
						dbo.fBuscaPorcentagem_PedidoProdutoCusto(FCI.Num_Proc_Lim,PS.cd_pedido,PS.cd_produto) *
						dbo.[Qty_Container] (FCI.Num_Proc_Lim)						
					END) ValorCusto,					
					NULL,
					'N' prestacao,
					GETDATE(),
					@cd_usuario,			
					'I',
					(case when dbo.[Qty_Container] (FCI.Num_Proc_Lim) = 0 then 					
						abs(TCC.Vlr_Item_Custo) * 
						dbo.fBuscaPorcentagem_PedidoProdutoCusto(FCI.Num_Proc_Lim,PS.cd_pedido,PS.cd_produto) *	1 else
						abs(TCC.Vlr_Item_Custo) * 
						dbo.fBuscaPorcentagem_PedidoProdutoCusto(FCI.Num_Proc_Lim,PS.cd_pedido,PS.cd_produto) *
						dbo.[Qty_Container] (FCI.Num_Proc_Lim)						
					end) Vlr_Item_Custo
				from 
					LLP_Imp_Mar FCI with(nolock)
					join Pedido_ship PS with(nolock) on FCI.Num_Proc_Lim = PS.num_proc
					left join Tarefas_Processos_Custo_Cliente TCC with(nolock) on FCI.Cd_Tp_Carga= TCC.Cd_Tp_Carga 					
				where 
					FCI.Num_Proc_Lim  =@Num_Proc 			
					and PS.cd_pedido is not Null 
					and PS.Cd_produto is not Null
					and (PS.qty > 0) 	
				group by 
					FCI.Num_Proc_Lim,PS.Cd_pedido,PS.Cd_produto,TCC.CD_tp_tx,TCC.Vlr_Item_Custo
		
		
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
					T.Num_proc,
					T.cd_pedido,
					T.Cd_Produto,
					T.Cd_tp_tx,
					T.Vlr_Item_Custo,
					T.Num_NF_Custo,		
					T.Prestacao,				
					T.Data_CC,
					T.cd_usuario,
					T.tp_oper_cc,
					T.Vlr_Item_Tx	
				from 
					@TAB_Custo T 
					left join custo_cliente CC with(nolock) on T.Num_Proc = CC.Num_Proc AND T.cd_pedido = CC.Cd_Pedido 
						AND T.cd_produto = CC.Cd_Produto and T.CD_tp_tx = CC.CD_tp_tx							
				where 
					T.Num_proc  = @Num_Proc	
					and CC.CD_tp_tx is null 
				group by 
					T.Num_proc,T.cd_pedido,T.Cd_Produto,T.Cd_tp_tx,T.Vlr_Item_Custo,T.Num_NF_Custo,		
					T.Prestacao,T.Data_CC,T.cd_usuario,T.tp_oper_cc,T.Vlr_Item_Tx			
		END	
		
		--select * from @TAB
		--select * from @TAB_Custo
		
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
	END
		
		
GO
ALTER TABLE [dbo].[Tarefas_Processos] ENABLE TRIGGER [TrgTarefas_Processos_Custo_Cliente_UpdN]
GO
