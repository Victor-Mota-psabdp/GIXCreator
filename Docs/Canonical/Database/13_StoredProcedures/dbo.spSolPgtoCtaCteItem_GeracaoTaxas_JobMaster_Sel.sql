SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from house_imp_mar where num_proc_mim  = 'IMSSZ201310009'
--select TT.Nome_Tp_Tx,TT.rateio_tx, * from vwcta_Cte V
--	join tipo_taxa TT on TT.Cd_Tp_Tx = V.Cd_Tp_Tx
--	where Num_Proc_HIA in 
--(select num_proc_him from house_imp_mar where num_proc_mim  = 'IMSSZ201310009')
	
--select * from Tipo_Taxa where Rateio_Tx = 'N'
--select * from Tipo_Taxa where Rateio_Tx = 'H'
--select * from Tipo_Taxa where Rateio_Tx = 'K'
--[spSolPgtoCtaCteItem_GeracaoTaxas_JobMaster_Sel] 'IMSSZ201310008','ADA','C','REL','BDP',1,1200.00

CREATE Procedure [dbo].[spSolPgtoCtaCteItem_GeracaoTaxas_JobMaster_Sel] --'IMFLT201206134AR'
			@Num_Proc_Master	Varchar(14),
			@cd_tp_tx	varchar(3),
			@dc			char(1),
			@cd_tp_moeda	varchar(6),	
			@cd_tp_par	varchar(6),
			@Paridade	float,		
			@vlr_total	float
AS

Declare @qty as int
set @qty = (select count(num_proc) from vwcliente where [Master]  = @Num_Proc_Master)
if @qty > 0
	Begin
		select 
			HIM.num_proc					[ItemProcesso],
			@cd_tp_tx						[cd_taxa],
			TT.Nome_Tp_Tx					[NomeTaxa],
			@dc								[DC],
			@cd_tp_moeda					[CdMoeda],
			TM.Nome_Tp_Moeda				[NomeMoeda],
			@vlr_total / @qty				[ValorOriginal],
			@cd_tp_par						[CdTipoParidade],
			TP.Nome_Tp_Par					[NomeTipoParidade],
			@Paridade						[Paridade],
			(@vlr_total / @qty) * @Paridade	[ValorTotal],
			@Num_Proc_Master				[Master]				
		from 
			vwcliente HIM
			join Tipo_taxa TT on TT.cd_tp_tx = @cd_tp_tx
			join Tipo_Moeda TM on TM.Cd_Tp_Moeda = @cd_tp_moeda
			join Tipo_Paridade TP on TP.Cd_Tp_Par= @cd_tp_par
		where 
			HIM.[Master]  = @Num_Proc_Master				
		
	End	



--Declare @rateio_tx as char(1)
--Declare @qty as int
--set @rateio_tx = (select rateio_tx from Tipo_Taxa where Cd_Tp_Tx = @cd_tp_tx)

--if @rateio_tx = 'H'
--	BEGIN
--		set @qty = (select count(num_proc_him) from house_imp_mar where num_proc_mim  = @Num_Proc_Master)
--		if @qty > 0
--			Begin
--				select 
--					HIM.num_proc					[ItemProcesso],
--					@cd_tp_tx						[cd_taxa],
--					TT.Nome_Tp_Tx					[NomeTaxa],
--					@dc								[DC],
--					@cd_tp_moeda					[CdMoeda],
--					TM.Nome_Tp_Moeda				[NomeMoeda],
--					@vlr_total / @qty				[ValorOriginal],
--					@cd_tp_par						[CdTipoParidade],
--					TP.Nome_Tp_Par					[NomeTipoParidade],
--					@Paridade						[Paridade],
--					(@vlr_total / @qty) * @Paridade	[ValorTotal]				
--				from 
--					vwcliente HIM
--					join Tipo_taxa TT on TT.cd_tp_tx = @cd_tp_tx
--					join Tipo_Moeda TM on TM.Cd_Tp_Moeda = @cd_tp_moeda
--					join Tipo_Paridade TP on TP.Cd_Tp_Par= @cd_tp_par
--				where 
--					HIM.Master  = @Num_Proc_Master					
				
--			End			
--	END
--else 
--	if @rateio_tx = 'K'
--		BEGIN
--			Select			
--				HIM.num_proc_him				[ItemProcesso],
--				@cd_tp_tx						[cd_taxa],
--				TT.Nome_Tp_Tx					[NomeTaxa],
--				@dc								[DC],
--				@cd_tp_moeda					[CdMoeda],
--				TM.Nome_Tp_Moeda				[NomeMoeda],				
--				@cd_tp_par						[CdTipoParidade],
--				TP.Nome_Tp_Par					[NomeTipoParidade],
--				@Paridade						[Paridade],
--				(@vlr_total / @qty) * @Paridade	[ValorTotal],
--				(Case 
--					When (Peso_Bruto_HIM/1000) > Vol_Tot_HIM 
--						then (Peso_Bruto_HIM/1000) * @vlr_total
--					Else 
--						Vol_Tot_HIM * @vlr_total End) [ValorOriginal],
--				(Case 
--					When (Peso_Bruto_HIM/1000) > Vol_Tot_HIM 
--						then (Peso_Bruto_HIM/1000) * @vlr_total * @Paridade
--					Else 
--						Vol_Tot_HIM * @vlr_total * @Paridade End) [ValorTotal]
						
--			from 
--				house_imp_mar HIM
--				join Tipo_taxa TT on TT.cd_tp_tx = @cd_tp_tx
--				join Tipo_Moeda TM on TM.Cd_Tp_Moeda = @cd_tp_moeda
--				join Tipo_Paridade TP on TP.Cd_Tp_Par= @cd_tp_par
--			where 
--				num_proc_mim  = @Num_Proc_Master		
		
--	END

GO
