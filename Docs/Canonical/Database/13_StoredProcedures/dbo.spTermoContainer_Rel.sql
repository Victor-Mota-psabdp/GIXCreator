SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--spTermoContainer_Rel 'IMVIX201510005'
CREATE procedure [dbo].[spTermoContainer_Rel]--'IMWTM201508001BR'
	@JOB varchar(16)
as

Declare @Produto varchar(max)

if LEN(@JOB) = 16
	Begin
		Select @Produto = COALESCE(@Produto + '; ','') + Produto_Descr   from Pedido_Ship PS  with(nolock)
		join vwCliente C  with(nolock) on PS.Num_Proc = C.num_proc
		join Pessoa_LLP PL  with(nolock) on C.cd_cliente = PL.Cd_Pes
		join Produto_Cliente PC  with(nolock) on PS.cd_produto = PC.cd_prod and PC.cd_Cliente = Pl.Cd_Pes_Grupo
		where PS.Num_Proc = @JOB


		select
			HOU.Num_Proc_HIM JOB,
			HOU.Navio_HIM Navio, 
			Viagem_HIM Viagem, 
			ORG.Nome_Local Origem, 
			DST.Nome_Local Destino, 
			HOU.HAWB_HIM Conhecimento,
			HOU.MAWB_HIM Master, 
			LLP.ATA_LIM ATA, 
			REPLACE(dbo.fBusca_Containers_Lacre (@JOB),';',CHAR(13)) Containers,
			CNS.Nome_Raz_Soc Cons_RazaoS, 
			CNS.Num_cpf_cnpj Cons_CNPJ, 
			CNS.Num_RG_IE Cons_RG_IE, -- Trans
			CNS.Num_Insc_Munic Cons_Insc_Munic, --Trans
			CNSE.Rua + ', ' + CNSE.numero + ' - ' + CNSE.Cidade + '/' + CNSE.UF + ' - ' + upper(CNSE.Pais) Endereco, 
			CNSE.CEP, dbo.fBusca_Volumes(@JOB) Volume,
			dbo.fNCM(@JOB) NCM, 
			dbo.fBusca_Docs_PO_Modal(@JOB,'1') PO, 
			CT.Contato, 
			CT.cd_area_fone + ' ' + CT.prefixo + '-' + CT.Num_fone Contato_Fone, 
			CT.Compl_Fone Email,
			CTNF1.Compl_Fone  Email_NF,
			CTFC1.cd_area_fone + ' ' + CTFC1.prefixo + '-' + CTFC1.Num_fone Contato_Fax,
			@Produto Produto
		from
			House_Imp_Mar HOU with(nolock)
			join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
			left Join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_him
			left Join Localidade DST with(nolock) on DST.cd_local = HOU.cd_dst_him
			join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_him
			left join endereco CNSE with(nolock) on CNSE.cd_pes = CNS.cd_pes and CNSE.cd_tp_end = 'COM'
			left join comunicacao CT with(nolock) on CT.cd_pes = CNS.cd_pes and CT.Cd_Tp_Com = 'TC2'
			left join comunicacao CTNF1 with(nolock) on CTNF1.cd_pes = CNS.cd_pes  and CTNF1.Cd_Tp_Com = 'NF2'
			left join comunicacao CTFC1 with(nolock) on CTFC1.cd_pes = CNS.cd_pes  and CTFC1.Cd_Tp_Com = 'FC2'
		where 
			HOU.Num_Proc_HIM = @JOB --'IMCAR20090600801'
	End
	
	if LEN(@JOB) = 14
		Begin	
		
			Declare @Containers varchar(max)
			Declare @Volume varchar(max)
			Declare @NCM varchar(max)
			Declare @PO varchar(max)
					
			Select @Produto = COALESCE(@Produto + '; ','') + Produto_Descr   from Pedido_Ship PS  with(nolock)
			join vwCliente C  with(nolock) on PS.Num_Proc = C.num_proc
			join Pessoa_LLP PL  with(nolock) on C.cd_cliente = PL.Cd_Pes
			join Produto_Cliente PC  with(nolock) on PS.cd_produto = PC.cd_prod and PC.cd_Cliente = Pl.Cd_Pes_Grupo
			where C.Master = @JOB
					
			select @Containers = COALESCE(@Containers + '; ','') + (MAS.num_cont_im + '  Seal: '+ Num_Lacre_IM + ' Type: ' +  TC.Nome_Tp_Cont )  from container_mas_imp_mar MAS
			join Tipo_Container TC with(nolock)on MAS.Cd_Tp_Cont  =TC.Cd_Tp_Cont
     			--join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
			where MAS.Num_Proc_MIM = @JOB 
			group by MAS.num_cont_im, TC.Nome_Tp_Cont,Num_Lacre_IM
			
			select @Volume = COALESCE(@Volume + '; ','') + (nome_tp_embal +' - '+ convert(varchar(30),qtd_vol_im))  from volume_imp_mar VOL with(nolock)
			join tipo_embalagem TE with(nolock) on VOL.cd_tp_embal = TE.cd_tp_embal
			join vwCliente vw with(nolock) on VOL.Num_Proc_HIM = vw.num_proc
			where vw.Master = @JOB
			
			
			select @NCM= COALESCE(@NCM + '; ','') + (case when right(NCM,4) = '0000' then left(NCM,4) else NCM end)  from Proc_NCM PN with(nolock)
			Join NCM N  with(nolock) on N.id_NCM = PN.id_NCM
			join vwCliente vw with(nolock) on PN.Num_Proc = vw.num_proc
			where vw.Master = @JOB
			
			select @PO= COALESCE(@PO + '; ','') + Numero_PO_HIM from PO_HIM PO with(nolock)  
			join vwCliente vw with(nolock) on PO.Num_Proc_HIM = vw.num_proc
			where vw.Master = @JOB and ID_DC='1'
			
			select
				HOU.Num_Proc_MIM JOB,
				HOU.Navio_MIM Navio, 
				Viagem_MIM Viagem, 
				ORG.Nome_Local Origem, 
				DST.Nome_Local Destino, 
				HOU.MAWB_MIM Conhecimento,
				HOU.MAWB_MIM Master, 
				LLP.ATA_Master ATA, 
				REPLACE(@Containers,';',CHAR(13)) Containers,
				CNS.Nome_Raz_Soc Cons_RazaoS, 
				CNS.Num_cpf_cnpj Cons_CNPJ, 
				CNS.Num_RG_IE Cons_RG_IE, -- Trans
				CNS.Num_Insc_Munic Cons_Insc_Munic, --Trans
				CNSE.Rua + ', ' + CNSE.numero + ' - ' + CNSE.Cidade + '/' + CNSE.UF + ' - ' + upper(CNSE.Pais) Endereco, 
				CNSE.CEP,@Volume Volume,
				@NCM NCM, 
				@PO PO, 
				CT.Contato, 
				CT.cd_area_fone + ' ' + CT.prefixo + '-' + CT.Num_fone Contato_Fone, 
				CT.Compl_Fone Email,
				CTNF1.Compl_Fone  Email_NF,
				CTFC1.cd_area_fone + ' ' + CTFC1.prefixo + '-' + CTFC1.Num_fone Contato_Fax,
				REPLACE(@Produto,';',CHAR(13)) Produto
			from
				Master_Imp_Mar HOU with(nolock)
				join LLP_Master LLP with(nolock) on LLP.Num_Proc_Master = HOU.Num_Proc_MIM
				left Join Localidade ORG with(nolock) on ORG.cd_local = HOU.Cd_Org_MIM
				left Join Localidade DST with(nolock) on DST.cd_local = HOU.Cd_Dst_MIM
				join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_MIM
				left join endereco CNSE with(nolock) on CNSE.cd_pes = CNS.cd_pes and CNSE.cd_tp_end = 'COM'
				left join comunicacao CT with(nolock) on CT.cd_pes = CNS.cd_pes and CT.Cd_Tp_Com = 'TC2'
				left join comunicacao CTNF1 with(nolock) on CTNF1.cd_pes = CNS.cd_pes  and CTNF1.Cd_Tp_Com = 'NF2'
				left join comunicacao CTFC1 with(nolock) on CTFC1.cd_pes = CNS.cd_pes  and CTFC1.Cd_Tp_Com = 'FC2'
			where 
				HOU.Num_Proc_MIM = @JOB --'IMCAR20090600801'
				
		End
GO
