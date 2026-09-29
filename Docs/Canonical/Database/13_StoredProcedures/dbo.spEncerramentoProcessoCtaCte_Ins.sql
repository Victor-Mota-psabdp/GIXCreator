SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spEncerramentoProcessoCtaCte_Ins]

		@ID int,
		@Nome_Usuario	Varchar(50),
		@Cd_Pes			Varchar(20)
		
AS

--Begin Transaction
	
	Declare @Cd_Tp_Tx_Local	Char(3)
	Declare @Nome_Tp_Tx Varchar(40)
	Declare @Num_Proc_Local	Varchar(16)
	Declare @Saldo		Decimal(10,2)
	Declare @DC_Local	Char(1)
	Declare @Data Varchar(10)
	
	Set @Data = Convert(varchar(10),getdate(),103)
	
	
	Declare cTemp Cursor For
			Select Distinct Num_Proc From Encerramento_Processo_Item
	
	Open Ctemp
		Fetch Next From cTemp Into @Num_Proc_Local
		While @@FETCH_STATUS = 0
			Begin
				Select top 1 @Nome_Tp_Tx=Nome_Tp_Tx, @Cd_Tp_Tx_Local=TT.Cd_Tp_tx from Tipo_taxa TT
				Left Join vwcta_Cte Cta on num_proc_hia=@Num_Proc_Local and cta.cd_tp_Tx=TT.cd_tp_TX
				Where cta.cd_Tp_tx is null  and nome_tp_Tx like 'Encerramento%'
				Order by Nome_Tp_Tx
				
				--Atualizado campo saldo
				Set @Saldo=Isnull((Select sum(Isnull(valor,0)) from Encerramento_Processo_Item where Tipo='Cta' and id=@id and num_proc=@Num_Proc_Local),0)
				Set @Saldo = @Saldo - Isnull((Select sum(Isnull(valor,0)) from Encerramento_Processo_Item where Tipo='NF' and  id=@id and num_proc=@Num_Proc_Local),0)
				if @Saldo=0
					BEgin
						return
					End
				if @Saldo < 0 
					Begin
						set @DC_Local='D'
						Set @Saldo=@Saldo*-1
					End
				Else
					Begin
						set @DC_Local='C'
					End
			
				--Inserindo CtA_Cte
				exec spCtaCte_InsUpd
						@Num_Proc=@Num_Proc_Local,
						@Cd_Tp_Tx=@Cd_Tp_Tx_Local,
						@DC=@DC_Local,
						@Org_Ins='ATL',
						@Dt_Ins=@Data,
						@Cd_Tp_Moeda='REL',
						@Vlr_Org=@Saldo,
						@Dt_Prev_Pgto=@Data,
						@Cd_Cred_Dev=@Cd_Pes,
						@Desp_Org='S',
						@CPMF='N',
						@Comp_RP='N',
						@Comp_DN='N',
						@Comp_CN='N',
						@Comp_CPA='N',
						@Num_DCN=Null,
						@Dt_Ctb_CC=Null,
						@Num_NF=@ID,
						@Ref_Acesso_NF='E',
						@Vlr_Pgto_NF=0,
						@Par_NF=0,
						@Comp_Job='N',
						@Contab=0,
						@Vlr_Contab=null,
						@Contab_Ant=0,
						@Vlr_Contab_Ant =null,
						@Contab_Mes_Ano=null,
						@Val_Con_Comp=Null;
				--Inserindo Log
				Exec spLogCtaCte_Ins
						@Usuario=@Nome_Usuario,
						@Tp_Oper_CC='I',
						@Num_Proc_CC=@Num_Proc_Local,
						@Tp_Tx=@Nome_Tp_Tx,
						@DC_CC=@DC_Local,
						@Org_Ins='ATL',
						@Dt_Ins=@Data,
						@Tp_Moeda='REAL',
						@Vlr_Org=@Saldo,
						@Dt_Prev_Pgto=@Data,
						@Cred_Dev=@Cd_Pes,
						@Desp_Org_Dst='S',
						@Comp_CPA='N',
						@Contab=0,
						@Vlr_Contab=Null,
						@Cointab_Mes_Ano=null;
						
				Fetch Next From cTemp Into @Num_Proc_Local			
			
			End
			close cTemp
			deallocate cTemp

--	if @@Error <> 0
--		Begin
--			Rollback transaction
--			return -1
--		End

--Commit Transaction



GO
