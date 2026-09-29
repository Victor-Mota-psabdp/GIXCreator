SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----18-10-2024 - job de testes 
---Marítimo 
--EMCSR201512009BR -- Alemanha Europa  
--EMARC202306002BR -- mexico
--EMARC201910019BR -- indonesia -  Jacarta 
--EMAMZ201709001BR -- india / india 
--EMAMZ201711001BR -- india(CHENNAI) / santos-brasil
----------------------------------------------------

--select * from PO_HEM where num_proc_hem = 'EMFLT201211004AR' 
CREATE PROCEDURE [dbo].[spHBL_EM_Package_Sel]--'emcbt201211006ar'--'IMFLT201103005AR'
	@Processo	varchar(16)
As

if LEFT(@Processo,2) = 'EM'
	BEGIN
----Antonio 15-10-2024 - LocICS2 verificar a região ------------------------------------------
		declare @LocICS2 bit
        declare @NatureGoodsICS varchar(3000)
        declare @NatureGoods varchar(3000)
  	    set @LocICS2 =(select  reg.LocICS2 from vwHouse_Exp hea with(nolock) 
					   join Localidade loc with(nolock) on loc.Cd_Local = hea.Cd_DstFinal	 
					   join Regiao reg with(nolock) on reg.Cd_Regiao = loc.Cd_Regiao
						        					 and reg.LocICS2 = 1  
					    where hea.Num_Proc =@Processo		
         		)
        if @LocICS2=1
		   Begin 
				 --set @NatureGoods = (select dbo.fBusca_Proc_Ncm_References(@Processo))
				 --set @NatureGoods = @NatureGoods + '|' + (select isnull(Descr,'')  as [Hand] 
  			--	 from Nature_Goods with(nolock) where num_proc=@Processo)

  				 set @NatureGoodsICS = (select dbo.fBusca_Proc_Ncm_References(@Processo))
				 set @NatureGoods = (select isnull(Descr,'|')  as [Hand] 
  				 from Nature_Goods with(nolock) where num_proc=@Processo)
                 set @NatureGoods =(select @NatureGoodsICS + ' | ' + isnull(@NatureGoods,''))

 		   End 

-------------------------------------------------------------------------------------------------------
		Select 
			--NG.Descr					Packages_GOODS,

		(case when (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais) in ('IN')) and UPPER(ENDN.Cd_Pais)in ('IN') 
			and NG.Descr IS null
		THEN
				isnull(NG.Descr,'') + '||CONTINUATION OF CONSIGNEE|' +
				isnull(CS.Nome_raz_soc,'') + '|' +
				isnull(ENDC.RUA,'') + isnull(ENDC.NUMERO,'') + isnull(ENDC.BAIRRO,'') + isnull(ENDC.CIDADE,'') + UPPER(isnull(ENDC.PAIS,'')) + '|' +
				--'zipcode: ' + ISNULL(ENDC.CEP,'') + '|' +
				'Import Export Code Number: ' + isnull(CP_IEC_CS.Campo_Dados,'') + '|' +
				'PAN NUMBER: ' + isnull(CP_PAN_CS.Campo_Dados,'') + '|' +
				'GST Number: ' + isnull(CP_GST_CS.Campo_Dados,'')	 + '|' +
				'Email ID: ' + isnull(CMC.compl_fone,'') 
				+ '|||CONTINUATION OF NOTIFY|' +	
				isnull(NF.Nome_raz_Soc,'') + '|' +
				isnull(ENDN.RUA,'') + isnull(ENDN.NUMERO,'') +isnull(ENDN.BAIRRO,'') +isnull(ENDN.CIDADE,'')+UPPER(isnull(ENDN.PAIS,'')) + '|' +
				--'zipcode: ' + ISNULL(ENDN.CEP,'') + '|' +
				--'Import Export Code Number'
				'PAN NUMBER: ' + isnull(CP_PAN_NF.Campo_Dados,'') + '|' +
				--'GST Number :' + isnull(CP_IEC_NF.Campo_Dados,'')	 + '|' +
				'Email ID : ' + isnull(CMCN.compl_fone,'') + '||' 			
				--'Total Invoice Value: ' + ISNULL(convert(varchar(25),llp.Vlr_Invoice),'')	
		else 
			(case when (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(DstFinal.Cd_Pais) in ('IN')) and UPPER(ENDN.Cd_Pais) not in ('IN') 
				and NG.Descr IS null
			THEN 
				isnull(NG.Descr,'') + '||CONTINUATION OF CONSIGNEE|' +
				isnull(CS.Nome_raz_soc,'') + '|' +
				isnull(ENDC.RUA,'') + isnull(ENDC.NUMERO,'') + isnull(ENDC.BAIRRO,'') + isnull(ENDC.CIDADE,'') + UPPER(isnull(ENDC.PAIS,'')) + '|' +
				--'zipcode: ' + ISNULL(ENDC.CEP,'') + '|' +
				'Import Export Code Number: ' + isnull(CP_IEC_CS.Campo_Dados,'') + '|' +
				'PAN NUMBER: ' + isnull(CP_PAN_CS.Campo_Dados,'') + '|' +
				'GST Number: ' + isnull(CP_GST_CS.Campo_Dados,'')	 + '|' +
				'Email ID: ' + isnull(CMC.compl_fone,'') + '||' 	
				--'Total Invoice Value: ' + ISNULL(convert(varchar(25),llp.Vlr_Invoice),'')
			else
----Antonio 15-10-2024 tratar a questão da Europa e outras exportações-----------------------
				(case when @LocICS2=1 
				then 
					@NatureGoods 
				else
					isnull(NG.Descr,'') 
				End) end) end) [Packages_GOODS] 
	
			--,			dbo.fBusca_Docs_PO_Modal(@Processo,4) [Permiso]	

			
		from house_exp_mar	Hou	 
			Left Outer Join	Nature_Goods NG	with(nolock)	on HOU.Num_Proc_HEM = NG.Num_Proc
			Left Outer Join	Master_exp_mar		MAS		with(nolock)	on MAS.num_proc_mem = HOU.num_proc_mem
			Left Outer Join LLP_exp_mar			LLP		with(nolock)	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
			Left Outer Join JOB_exp_mar			JOB		with(nolock)	on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM

			Left Outer Join Pessoa				SH		with(nolock)	on SH.cd_pes = cd_export_hem 
			Left Outer Join Endereco			ENDS	with(nolock)	on SH.cd_pes = ENDS.cd_pes and ENDS.cd_tp_end = 'COM' 
			Left Outer Join comunicacao			CMCS	with(nolock)	on SH.cd_pes = CMCS.cd_pes and CMCS.cd_tp_com = 'HBL'
			
			Left Outer Join Pessoa				CS		with(nolock)	on CS.cd_pes=cd_consig_hem
			Left Outer Join Endereco			ENDC	with(nolock)	on CS.cd_pes=ENDC.cd_pes  and ENDC.cd_tp_end = 'COM'	
			Left Outer Join comunicacao			CMC		with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'	
		 
			Left Outer Join Pessoa				NF		with(nolock)	on NF.cd_pes = HOU.cd_notify_hem
			Left Outer Join Endereco			ENDN	with(nolock)	on NF.cd_pes = ENDN.cd_pes  and ENDN.cd_tp_end = 'COM' 
			Left Outer Join comunicacao			CMCN	with(nolock)	on NF.cd_pes = CMCN.cd_pes and CMCN.cd_tp_com = 'HBL'
		  
			Left Outer Join Localidade			LCO		with(nolock)	on HOU.cd_org_Hem = LCO.cd_local
			Left Outer Join Localidade			LCD		with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade			Origin	with(nolock)	on LLP.Cd_Planta_Lem	= Origin.Cd_Local
			Left Outer Join Localidade			DstFinal with(nolock)	on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
			left Outer join Campo_Pessoa		CP_PAN_CS with(nolock)	on CP_PAN_CS.Cd_Pes = CS.Cd_Pes and CP_PAN_CS.Id_Campo = '20'
			left Outer join Campo_Pessoa		CP_IEC_CS with(nolock)	on CP_IEC_CS.Cd_Pes = CS.Cd_Pes and CP_IEC_CS.Id_Campo = '21'
			left Outer join Campo_Pessoa		CP_GST_CS with(nolock)	on CP_GST_CS.Cd_Pes = CS.Cd_Pes and CP_GST_CS.Id_Campo = '22'
			
			left Outer join Campo_Pessoa		CP_PAN_NF with(nolock)	on CP_PAN_NF.Cd_Pes = NF.Cd_Pes and CP_PAN_NF.Id_Campo = '20'
			left Outer join Campo_Pessoa		CP_IEC_NF with(nolock)	on CP_IEC_NF.Cd_Pes = NF.Cd_Pes and CP_IEC_NF.Id_Campo = '21'
			
		where
			--NG.num_proc=@Processo
			Hou.Num_Proc_HEM=@Processo
	END
else
    Begin 
		Select 	NG.Descr Packages_GOODS from Nature_Goods NG with(nolock) where NG.num_proc=@Processo
    End  
-----------------------------------------------------------------------------------------------
GO
