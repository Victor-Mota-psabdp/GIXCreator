SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spTaxasBDPInvoiceErbson_Sel'EMSEL201307001BR', 'BDP (MEXICO)'
--spTaxasBDPInvoiceErbson_Sel'EMSEL201304002BR', 'BDPT'






CREATE procedure [dbo].[spTaxasBDPInvoiceErbson_Sel]-- spTaxasBDPInvoice_Sel 'EMATL201305019BR', 'BDPT'
(
	@Processo varchar(16),
	@Pessoa varchar(50)
)

AS
SET NOCOUNT ON
	Declare @CdPes varchar(10)
	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)
			
		)
	Declare @TempTaxas Table
	(
		Moeda		varchar(3),
		Paridade	varchar(10),
		Nome_tp_tx	varchar(50),
		Valor		varchar(10),
		cd_tp_tx	varchar(10),
		Cd_Pes		varchar(10),
		DC			varchar(1),
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1)
	)
	Begin 		
		Insert @Fatura	
		Select left(i.fatcod,16),cd_tp_Tx,dc from item_fat I
		Join Fatura F on F.fatcod=i.fatcod 
		where
			left(f.fatcod,16)=@Processo and fatstatus =1
	End		
	If @Pessoa <> '' 
		begin
				set @cdPes = (Select cd_pes from pessoa where apelido = @Pessoa)
		end
	
	If @Pessoa = ''
		Begin
			Insert @TempTaxas
			SELECT 
				distinct cc.cd_tp_moeda Moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEM*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hem Cd_Pes,cc.dc_hem DC 
				,CC.num_nf_hem NF, CC.ref_acesso_nf_hem [Site]
				,Repasse_TX 
			FROM 
				Cta_Cte_Hou_Exp_Mar CC
				left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Mar HOU on HOU.num_proc_HEM = CC.num_proc_HEM and HOU.cd_export_hem = cc.cd_cred_dev_hem
				Left join Caixa_Hou_Exp_Mar CXA on	CC.num_proc_HEM	= CXA.num_proc_HEM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HEM
--				Left Join item_Fat FAT on CC.num_proc_HEM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc    
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEM = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_dst_hem='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hea Cd_Pes,cc.dc_hea 
				,CC.num_nf_hea NF, CC.ref_acesso_nf_hea [Site]
				,Repasse_TX				
			FROM 
				Cta_Cte_Hou_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Aer HOU on HOU.num_proc_HEA = CC.num_proc_HEA and HOU.cd_export_hea = cc.cd_cred_dev_hea
				Left join Caixa_Hou_Exp_Aer CXA on	CC.num_proc_HEA	= CXA.num_proc_HEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HEA
	--			Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc    
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEA = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_dst_hea='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEO*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_heo Cd_Pes,cc.dc_heo 
				,CC.num_nf_heo NF, CC.ref_acesso_nf_heo [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Exp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Out HOU on HOU.num_proc_HEO = CC.num_proc_HEO and HOU.cd_export_heo = cc.cd_cred_dev_heo
				Left join Caixa_Hou_Exp_Out CXA on	CC.num_proc_HEO	= CXA.num_proc_HEO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEO = CXA.dc_HEO
--				Left Join fatura_chb_item FAT on CC.num_proc_HEO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc    
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEO = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_heo='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIM*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_him Cd_Pes,cc.dc_him 
				,CC.num_nf_him NF, CC.ref_acesso_nf_him [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Mar HOU on HOU.num_proc_HIM = CC.num_proc_HIM and HOU.cd_consig_him = cc.cd_cred_dev_him
				Left join Caixa_Hou_Imp_Mar CXA on	CC.num_proc_HIM	= CXA.num_proc_HIM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIM = CXA.dc_HIM
--				Left Join fatura_chb_item FAT on CC.num_proc_HIM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc   
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HIM = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_him='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hia Cd_Pes,cc.dc_hia 
				,CC.num_nf_hia NF, CC.ref_acesso_nf_hia [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Aer HOU on HOU.num_proc_HIA = CC.num_proc_HIA and HOU.cd_consig_hia = cc.cd_cred_dev_hia
				Left join Caixa_Hou_Imp_Aer CXA on	CC.num_proc_HIA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIA = CXA.dc_HIA
--				Left Join fatura_chb_item FAT on CC.num_proc_HIA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1	
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc   
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HIA = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_hia='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIO*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hio Cd_Pes,cc.dc_hio 
				,CC.num_nf_hio NF, CC.ref_acesso_nf_hio [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Out HOU on HOU.num_proc_HIO = CC.num_proc_HIO and HOU.cd_consig_hio = cc.cd_cred_dev_hio
				Left join Caixa_Hou_Imp_Out CXA on	CC.num_proc_HIO	= CXA.num_proc_HIO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIO = CXA.dc_HIO
--				Left Join fatura_chb_item FAT on CC.num_proc_HIO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc   
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HIO = @Processo and Fat.num_proc is null
				and desp_org_hio='N'
		end
	else
		begin
		Insert @TempTaxas
			SELECT 
				distinct cc.cd_tp_moeda Moeda,
--				1 Paridade,
				(case When
					CC.Num_NF_HEM is not NULL
				Then 
					CC.Par_NF_Hem 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,				
--				sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
 
				TT.Nome_tp_tx,vlr_org_HEM Valor, CC.cd_tp_tx, CC.cd_cred_dev_hem Cd_Pes,cc.dc_hem DC 
				,CC.num_nf_hem NF, CC.ref_acesso_nf_hem [Site]
				,Repasse_TX
			FROM Cta_Cte_Hou_Exp_Mar CC
				left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Mar CXA on	CC.num_proc_HEM	= CXA.num_proc_HEM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HEM
		--		Left Join fatura_chb_item FAT on CC.num_proc_HEM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
				--Left Join item_Fat FAT on CC.num_proc_HEM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
			--	Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEM = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hem = @cdPes
				and desp_dst_hem='N'
				
		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,		
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') Paridade,	 
				TT.Nome_tp_tx,vlr_org_HEA Valor, CC.cd_tp_tx, CC.cd_cred_dev_hea Cd_Pes,cc.dc_hea DC 
				,CC.num_nf_hea NF, CC.ref_acesso_nf_hea [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Aer CXA on	CC.num_proc_HEA	= CXA.num_proc_HEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HEA
--				Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEA = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hea = @cdPes
				and desp_dst_hea='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') Paridade,
				TT.Nome_tp_tx,vlr_org_HEO Valor, CC.cd_tp_tx, CC.cd_cred_dev_heo Cd_Pes,cc.dc_heo DC 
				,CC.num_nf_heo NF, CC.ref_acesso_nf_heo [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Exp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Out CXA on	CC.num_proc_HEO	= CXA.num_proc_HEO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEO = CXA.dc_HEO
--				Left Join fatura_chb_item FAT on CC.num_proc_HEO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HEO = @Processo and Fat.num_proc is null and CC.cd_cred_dev_heo = @cdPes
				and desp_org_heo='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') Paridade,
				TT.Nome_tp_tx,vlr_org_HIM Valor, CC.cd_tp_tx, CC.cd_cred_dev_him Cd_Pes,CC.dc_him 
				,CC.num_nf_him NF, CC.ref_acesso_nf_him [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Mar CXA on	CC.num_proc_HIM	= CXA.num_proc_HIM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIM = CXA.dc_HIM
--				Left Join fatura_chb_item FAT on CC.num_proc_HIM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc 
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HIM = @Processo and Fat.num_proc is null and CC.cd_cred_dev_him = @cdPes
				and desp_org_him='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') Paridade,
				TT.Nome_tp_tx,vlr_org_HIA Valor, CC.cd_tp_tx, CC.cd_cred_dev_hia Cd_Pes,cc.dc_hia 
				,CC.num_nf_hia NF, CC.ref_acesso_nf_hia [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Aer CXA on	CC.num_proc_HIA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIA = CXA.dc_HIA
--				Left Join fatura_chb_item FAT on CC.num_proc_HIA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1	
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc 
			WHERE 
				CXA.Num_Lcto is null  and CC.Num_Proc_HIA = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hia = @cdPes
				and desp_org_hia='N'

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') Paridade,
				TT.Nome_tp_tx,vlr_org_HIO Valor, CC.cd_tp_tx, CC.cd_cred_dev_hio Cd_Pes,cc.dc_hio 
				,CC.num_nf_hio NF, CC.ref_acesso_nf_hio [Site]
				,Repasse_TX
			FROM 
				Cta_Cte_Hou_Imp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Out CXA on	CC.num_proc_HIO	= CXA.num_proc_HIO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIO = CXA.dc_HIO
--				Left Join fatura_chb_item FAT on CC.num_proc_HIO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc  
			WHERE 
				CXA.Num_Lcto is null and CC.Num_Proc_HIO = @Processo and Fat.num_proc is null and  CC.cd_cred_dev_hio = @cdPes
				and desp_org_hio='N'

	end
	
select Moeda,* from @TempTaxas
where NF is not NULL
	
select * from @TempTaxas
	



















GO
