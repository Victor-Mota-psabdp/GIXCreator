SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spRManagerv2House_Sel]
			@Num_PRoc	Varchar(16),
			@Notify		Varchar(50) Output,
			@Incoterm	Varchar(3)	Output,
			@Consignee	Varchar(50) output,
			@Shipper	Varchar(50) output,
			@CNPJ		Varchar(40) output,
			@ConsigneeAddress Varchar(500) output,
			@CityofConsignee  Varchar(25) output,
			@ShipperAddress		Varchar(150) output,
			@VolumeM3			Decimal(10,2) output,
			@SellerCode			Varchar(15) output,
			@FreightCurrency	varchar(30) output,
			@Notes	varchar(400) output,
			@RegionofOrigin varchar(50) output,
			@RegionofDestination varchar(50) output,
			@LLPUNIT varchar(20) output,
			@Vessel varchar(50) output


AS


IF LEFT(@Num_Proc,2)='IM'
	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = C.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_him,
				@SellerCode=Cd_Export_him,
				@FreightCurrency = TM.Nome_Tp_Moeda, 
				@Notes = left(Obs_HIM,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.Nome_Regiao,
				@LLPUNIT= GRP.Admin,
				@Vessel = HOU.Navio_HIM
		from 
				house_imp_mar HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_import_him
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_him
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_him
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_him and Ed.cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Him and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HIM
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HIM
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Consig_HIM
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
		Where
				Num_Proc_Him=@num_proc
	End
IF LEFT(@Num_Proc,2)='EM'

	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = S.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_hem,
				@SellerCode=Cd_Export_hem,
				@FreightCurrency = TM.Nome_Tp_Moeda,
				@Notes = left(Obs_HEM,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.nome_regiao,
				@LLPUNIT= GRP.Admin,
				@Vessel = HOU.Navio_HeM
		from 
				house_exp_mar HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_notify_hem
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_hem
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_hem
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_hem and cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Hem and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HEM
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HEM
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Export_hem
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
		Where
				Num_Proc_Hem=@num_proc
	End
IF LEFT(@Num_Proc,2)='IA'

	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = C.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_hia,
				@SellerCode=Cd_Export_hia,
				@FreightCurrency = TM.Nome_Tp_Moeda,
				@Notes = left(Obs_HIA,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.nome_regiao,
				@LLPUNIT= GRP.Admin,
				@Vessel = HOU.Voo_HIA
		from 
				house_imp_aer HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_import_hia
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_hia
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_hia
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_hia and cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Hia and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HIA
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HIA
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Consig_HIa
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
		Where
				Num_Proc_Hia=@num_proc
	End

IF LEFT(@Num_Proc,2)='EA'

	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = S.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_hea,
				@SellerCode=Cd_Export_hea,
				@FreightCurrency = TM.Nome_Tp_Moeda,
				@Notes = left(obs_HEA,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.nome_regiao,
				@LLPUNIT= GRP.Admin,
				@Vessel = HOU.Voo_HEA
		from 
				house_exp_aer HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_notify_hea
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_hea
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_hea
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_hea and cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Hea and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HEA
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HEA
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Export_hea
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
		Where
				Num_Proc_Hea=@num_proc
	End
IF LEFT(@Num_Proc,2)='IO'

	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = C.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_hio,
				@SellerCode=Cd_Export_hio,
				@FreightCurrency = TM.Nome_Tp_Moeda,
				@Notes = left(Obs_HIO,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.nome_regiao,
				@LLPUNIT= GRP.Admin
		from 
				house_imp_out HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_import_hio
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_hio
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_hio
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_hio and cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Hio and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HIO
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HIO
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Consig_HIo
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo								
		Where
				Num_Proc_Hio=@num_proc
	End


IF LEFT(@Num_Proc,2)='EO'

	Begin

		Select 
				@Notify=N.Nome_raz_soc,
				@Incoterm=cd_tp_oper,
				@Consignee = C.Nome_Raz_Soc,
				@Shipper = S.Nome_Raz_Soc,
				@CNPJ = S.num_cpf_cnpj,
				@ConsigneeAddress= (isnull(ED.rua,' ') + isnull(ED.numero,' ') + isnull(ED.Cidade,'')) ,
				@CityofConsignee=ED.Cidade,
				@ShipperAddress=left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150),
				@VolumeM3=Vol_Tot_heo,
				@SellerCode=Cd_Export_heo,
				@FreightCurrency = TM.Nome_Tp_Moeda,
				@Notes = left(Obs_HEO,400),
				@RegionofOrigin = RORG.nome_regiao,
				@RegionofDestination = RDST.nome_regiao,
				@LLPUNIT= GRP.Admin
		from 
				house_exp_out HOU with(nolock)
				Join Pessoa N with(nolock) on N.cd_pes=HOU.cd_notify_heo
				Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig_heo
				Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export_heo
				Left Join Endereco ED with(nolock) on ED.cd_pes=HOU.Cd_Consig_heo and cd_tp_end='COM'
				Left Join Endereco EDSH with(nolock) on EDSH.cd_pes=HOU.cd_Export_Heo and EDSH.cd_tp_end='COM'
				left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
				Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org_HEO
				Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst_HEO
				Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
				Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
				left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.Cd_Export_heo
				Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
		Where
				Num_Proc_Heo=@num_proc
	End

set @SellerCode=(select isnull(cd_vendor,cd_planta) from pessoa_llp with(nolock) where cd_pes=@SellerCode)




GO
