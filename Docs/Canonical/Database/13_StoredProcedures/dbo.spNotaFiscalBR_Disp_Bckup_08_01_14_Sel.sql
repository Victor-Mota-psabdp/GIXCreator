SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spNotaFiscalBR_Disp_Sel  'UPL ITUVERAV 0003/14','rgl'
--incluido dia 27-06 não trazer tipo taxas com NF ='N' -CAdu
--incluido pra não trazer os casos que já possuem fatura vinculada a taxa - 22/07/2013 - Cadu
--incluido pra qdo for os users abaixo, usar a stored antiga q nao verifica se ja existe item fat vinculada a taxa
--revogada a autorização - Osney - 5/8
CREATE procedure [dbo].[spNotaFiscalBR_Disp_Bckup_08_01_14_Sel]

	@Cliente varchar(50),
	@cd_user varchar(6)

as
SET NOCOUNT ON
	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes from pessoa where apelido = @Cliente)

--	if @cd_user not in ('has','rgl','TTS','lts','acsc','cso','lls','AZ','admin','apsa','avc','amc')
	if @cd_user not in ('ninguemAutorizado')
		Begin
			Declare @Fatura Table
				(
					Num_proc	varchar(16),
					Cd_tp_Tx	Varchar(3),
					DC			Varchar(1)			
				)
			Begin 		
				Insert @Fatura	
					Select left(i.fatcod,16),cd_tp_Tx,dc from item_fat I
					Join Fatura F on F.fatcod=i.fatcod 
				where
					cd_pes=@CD_PES and fatstatus =1
			End	

		select CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hem Vlr_Org,Par_Moeda_hem Par_Moeda from cta_cte_hou_exp_mar CC
			join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_exp_mar CXA on CC.Num_proc_hem = CXA.Num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc   
		where 
			convert(datetime,dt_ins_hem,103) > getdate() - 450 and left(CC.Num_Proc_hem,5) <>'EMJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')  and CC.cd_cred_dev_hem = @CD_pes 
			and CC.Num_Nf_Hem is null and NF = 'S'  
			and Fat.num_proc is null

		union

		select CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, Par_Moeda_him Par_Moeda from cta_cte_hou_imp_mar CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_imp_mar CXA on CC.Num_proc_him = CXA.Num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc   
		where 
			convert(datetime,dt_ins_him,103) > getdate() - 450 and left(CC.Num_Proc_him,5) <>'IMJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_him = @CD_pes 
			and CC.Num_Nf_Him is null and NF = 'S'  and Fat.num_proc is null

		union

		select CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, Par_Moeda_hia Par_Moeda from cta_cte_hou_imp_aer CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_imp_aer CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc   
		where 
			convert(datetime,dt_ins_hia,103) > getdate() - 450 and left(CC.Num_Proc_hia,5) <>'IAJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hia = @CD_pes 
			and CC.Num_Nf_Hia is null and NF = 'S'  
			and Fat.num_proc is null

		union 

		select CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, Par_Moeda_hea Par_Moeda from cta_cte_hou_exp_aer CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_exp_aer CXA on CC.Num_proc_hea = CXA.Num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc   
		where 
			convert(datetime,dt_ins_hea,103) > getdate() - 450 and left(CC.Num_Proc_hea,5) <>'EAJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hea = @CD_pes 
			and CC.Num_Nf_Hea is null and NF = 'S'  
			and Fat.num_proc is null


		union

		select CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, Par_Moeda_heo Par_Moeda from cta_cte_hou_exp_out CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_exp_out CXA on CC.Num_proc_heo = CXA.Num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc   
		where 
			convert(datetime,dt_ins_heo,103) > getdate() - 450 and left(CC.Num_Proc_heo,5) <>'EOJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_heo = @CD_pes 
			and CC.Num_Nf_Heo is null and NF = 'S'  
			and Fat.num_proc is null

		union

		select CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, Par_Moeda_hio Par_Moeda from cta_cte_hou_imp_out CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_hou_imp_out CXA on CC.Num_proc_hio = CXA.Num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc   
		where 
			convert(datetime,dt_ins_hio,103) > getdate() - 450 and left(CC.Num_Proc_hio,5) <>'IOJOB' 
			and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hio = @CD_pes 
			and CC.Num_Nf_Hio is null and NF = 'S' 
			and Fat.num_proc is null

		union

		---Processos master

		select CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, Par_Moeda_mia Par_Moeda from cta_cte_mas_imp_aer CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_mas_imp_aer CXA on CC.Num_proc_mia = CXA.Num_proc_mia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mia = CXA.dc_mia
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mia=fat.dc   
		where 
			convert(datetime,dt_ins_mia,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mia = @CD_pes 
			and CC.Num_Nf_mia is null and NF = 'S' 
			and Fat.num_proc is null

		union

		select CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, Par_Moeda_mea Par_Moeda from cta_cte_mas_exp_aer CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_mas_exp_aer CXA on CC.Num_proc_mea = CXA.Num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mea=fat.dc  
		where 
			convert(datetime,dt_ins_mea,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mea = @CD_pes 
			and CC.Num_Nf_mea is null and NF = 'S' 
			and Fat.num_proc is null

		Union

		select CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, Par_Moeda_mim Par_Moeda from cta_cte_mas_imp_mar CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_mas_imp_mar CXA on CC.Num_proc_mim = CXA.Num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mim and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mim=fat.dc  
		where 
			convert(datetime,dt_ins_mim,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mim = @CD_pes 
			and CC.Num_Nf_mim is null and NF = 'S' 
			and Fat.num_proc is null

		union

		select CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, Par_Moeda_mem Par_Moeda from cta_cte_mas_exp_mar CC
			join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
			left Outer Join caixa_mas_exp_mar CXA on CC.Num_proc_mem = CXA.Num_proc_mem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mem = CXA.dc_mem
			Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mem=fat.dc  
		where
			convert(datetime,dt_ins_mem,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mem = @CD_pes 
			and CC.Num_Nf_mem is null and NF = 'S' 
			and Fat.num_proc is null

		order by Processo
	End
Else
	Begin		
		select CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hem Vlr_Org, Par_Moeda_hem Par_Moeda from cta_cte_hou_exp_mar CC
		join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_exp_mar CXA on CC.Num_proc_hem = CXA.Num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem
		where convert(datetime,dt_ins_hem,103) > getdate() - 450 and left(CC.Num_Proc_hem,5) <>'EMJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')  and CC.cd_cred_dev_hem = @CD_pes and CC.Num_Nf_Hem is null
		and NF = 'S'

		union

		select CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, Par_Moeda_him Par_Moeda from cta_cte_hou_imp_mar CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_imp_mar CXA on CC.Num_proc_him = CXA.Num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him
		where convert(datetime,dt_ins_him,103) > getdate() - 450 and left(CC.Num_Proc_him,5) <>'IMJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_him = @CD_pes and CC.Num_Nf_Him is null
		and NF = 'S'

		union

		select CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, Par_Moeda_hia Par_Moeda from cta_cte_hou_imp_aer CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_imp_aer CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia
		where convert(datetime,dt_ins_hia,103) > getdate() - 450 and left(CC.Num_Proc_hia,5) <>'IAJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hia = @CD_pes and CC.Num_Nf_Hia is null
		and NF = 'S'

		union 

		select CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, Par_Moeda_hea Par_Moeda from cta_cte_hou_exp_aer CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_exp_aer CXA on CC.Num_proc_hea = CXA.Num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea
		where convert(datetime,dt_ins_hea,103) > getdate() - 450 and left(CC.Num_Proc_hea,5) <>'EAJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hea = @CD_pes and CC.Num_Nf_Hea is null
		and NF = 'S'


		union

		select CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, Par_Moeda_heo Par_Moeda from cta_cte_hou_exp_out CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_exp_out CXA on CC.Num_proc_heo = CXA.Num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo
		where convert(datetime,dt_ins_heo,103) > getdate() - 450 and left(CC.Num_Proc_heo,5) <>'EOJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_heo = @CD_pes and CC.Num_Nf_Heo is null
		and NF = 'S'


		union

		select CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, Par_Moeda_hio Par_Moeda from cta_cte_hou_imp_out CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_hou_imp_out CXA on CC.Num_proc_hio = CXA.Num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio
		where convert(datetime,dt_ins_hio,103) > getdate() - 450 and left(CC.Num_Proc_hio,5) <>'IOJOB' and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hio = @CD_pes and CC.Num_Nf_Hio is null
		and NF = 'S'

		union

		select CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, Par_Moeda_mia Par_Moeda from cta_cte_mas_imp_aer CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_mas_imp_aer CXA on CC.Num_proc_mia = CXA.Num_proc_mia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mia = CXA.dc_mia
		where convert(datetime,dt_ins_mia,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mia = @CD_pes and CC.Num_Nf_mia is null
		and NF = 'S'

		union

		select CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, Par_Moeda_mea Par_Moeda from cta_cte_mas_exp_aer CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_mas_exp_aer CXA on CC.Num_proc_mea = CXA.Num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea
		where convert(datetime,dt_ins_mea,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mea = @CD_pes and CC.Num_Nf_mea is null
		and NF = 'S'

		Union

		select CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, Par_Moeda_mim Par_Moeda from cta_cte_mas_imp_mar CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_mas_imp_mar CXA on CC.Num_proc_mim = CXA.Num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim
		where convert(datetime,dt_ins_mim,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mim = @CD_pes and CC.Num_Nf_mim is null
		and NF = 'S'

		union

		select CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, Par_Moeda_mem Par_Moeda from cta_cte_mas_exp_mar CC
		join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Outer Join caixa_mas_exp_mar CXA on CC.Num_proc_mem = CXA.Num_proc_mem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mem = CXA.dc_mem
		where convert(datetime,dt_ins_mem,103) > getdate() - 450 and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_mem = @CD_pes and CC.Num_Nf_mem is null
		and NF = 'S'
		order by Processo
	End

GO
