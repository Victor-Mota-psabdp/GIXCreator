SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spRegistroFinanceiroChecking_Sel]
		@Num_Proc	Varchar(16),
		@Item		Varchar(2),
		@nometptx	Varchar(40),
		@dc			Char(1)

AS
--Checking utilizado para limpar o campo Num_NF_Modal para casos que usuário troque o número do job no item;

if not exists(
				select ID_Item from dbo.Registro_Financeiro_Item R
				Join Tipo_Taxa TT on tt.cd_tp_tx=R.cd_tp_Tx
				Where
				Num_PRoc=@Num_Proc and Nome_Tp_Tx=@Nometptx	and ID_item=@item
			)	
	Begin
		Declare @Cd_Tp_TX Varchar(3)
		select @Num_PRoc=num_proc,@cd_tp_Tx=cd_tp_Tx,@dc=DC from Registro_Financeiro_Item where id_item=@item

		if len(@num_proc)=16
			
			Begin 
				if upper(left(@num_proc,2))='IA'
					Begin
						Update Cta_Cte_Hou_Imp_Aer Set Num_NF_Hia=null where num_proc_hia=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_hia=@DC
					End
				if upper(left(@num_proc,2))='IM'
					Begin
						Update Cta_Cte_Hou_Imp_Mar Set Num_NF_HiM=null where num_proc_hiM=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_him=@DC
					End
				if upper(left(@num_proc,2))='IO'
					Begin
						Update Cta_Cte_Hou_Imp_Out Set Num_NF_Hio=null where num_proc_hio=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_hio=@DC
					End
				if upper(left(@num_proc,2))='EA'
					Begin
						Update Cta_Cte_Hou_exp_Aer Set Num_NF_Hea=null where num_proc_hea=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_hea=@DC
					End
				if upper(left(@num_proc,2))='EM'
					Begin
						Update Cta_Cte_Hou_exp_mar Set Num_NF_Hem=null where num_proc_hem=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_hem=@DC
					End
				if upper(left(@num_proc,2))='EO'
					Begin
						Update Cta_Cte_Hou_exp_out Set Num_NF_Heo=null where num_proc_heo=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_heo=@DC
					End
			End


		if len(@num_proc)=14
			
			Begin 
				if upper(left(@num_proc,2))='IA'
					Begin
						Update Cta_Cte_MAS_Imp_Aer Set Num_NF_Mia=null where num_proc_mia=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_mia=@DC
					End
				if upper(left(@num_proc,2))='IM'
					Begin
						Update Cta_Cte_MAS_Imp_Mar Set Num_NF_MiM=null where num_proc_MiM=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_Mim=@DC
					End
				if upper(left(@num_proc,2))='EA'
					Begin
						Update Cta_Cte_Mas_exp_Aer Set Num_NF_Mea=null where num_proc_mea=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_mea=@DC
					End
				if upper(left(@num_proc,2))='EM'
					Begin
						Update Cta_Cte_mas_exp_mar Set Num_NF_mem=null where num_proc_mem=@num_proc and cd_tp_Tx=@Cd_tp_Tx and dc_mem=@DC
					End
			End


	End

	

	

GO
