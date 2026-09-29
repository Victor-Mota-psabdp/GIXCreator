SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from AX_XML_Customer_Recebido where dt_atualiza_atl is null

CREATE procedure [dbo].[spAX_Endereco_Customer_InsUpd]

as

	Declare @cd_pes			varchar(10)
	Declare @Apelido		varchar(20)
	--endereco
	Declare	@Tipo_Endereco	varchar(50)
	Declare	@Rua			varchar(50)
	Declare	@Numero			varchar(50)
	Declare	@Compl_End		varchar(50)
	Declare	@CEP			varchar(50)
	Declare	@Bairro			varchar(50)
	Declare	@Cidade			varchar(50)
	Declare	@UF				varchar(50)
	Declare @pais			varchar(50)
	
	Declare @Temp			varchar(2000)
	
	Declare @JOBs Table 
			(
			[cd_pes]		varchar(50),
			[Apelido]		varchar(20),		
			[AccountNum]	varchar(50),
			--endereco
			[Tipo_Endereco] varchar(50),
			[Rua]			varchar(80),
			[Numero]		varchar(50),
			[Compl_End]		varchar(50),
			[CEP]			varchar(50),
			[Bairro]		varchar(50),
			[Cidade]		varchar(50),
			[UF]			varchar(50),
			[Pais]			varchar(50)		
			)
	Begin
		Insert into @JOBs			
			select
				Ax.OurAccountNum					[cd_pes],
				[dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(NameAlias)))	[Apelido],		
				AccountNum							[AccountNum],
				--endereco
				'Comercial'									[Tipo_Endereco],
				ltrim(rtrim([dbo].[FRemoveCaracteresEspeciais](isnull(street,isnull(Street3,Street4)))))		[Rua],
				isnull(addressNumber4,isnull(addressNumber5,addressNumber3))			[Numero],
				[dbo].[FRemoveCaracteresEspeciais](isnull(AddressComplement4,isnull(addressComplement3,AddressComplement)))	[Compl_End],
				isnull(zipcode,isnull(ZipCode3,isnull(zipcode5,ZipCode4)))				[CEP],
				isnull(DistrictName,isnull(DistrictName5,isnull(DistrictName3,DistrictName4)))	[Bairro],
				isnull(City4,isnull(City5,isnull(City3,City)))							[Cidade],
				isnull(state,isnull(State3,isnull(state5,state4)))						[UF],
				isnull(PA.Nome_pais,isnull(P3.nome_pais,isnull(P4.nome_pais,P5.nome_pais)))	[Pais]
			from ax_xml_Customer_recebido AX with (nolock)
				left join PAIS PA with (nolock) on PA.cd_pais = AX.CountryRegionID
				left join PAIS P3 with (nolock) on P3.cd_pais = AX.CountryRegionID3
				left join PAIS P4 with (nolock) on P4.cd_pais = AX.CountryRegionID4
				left join PAIS P5 with (nolock) on P5.cd_pais = AX.CountryRegionID5
--				where
--				 Dt_Atualiza_ATL is null
--				 accountNUm = 1662
		
	End

--Endereco
Declare C_END cursor for
--
		Select P.cd_pes,[Tipo_Endereco],[Rua],[Numero],[Compl_End],
		[CEP],[Bairro],[Cidade],[UF],[Pais]
		from @JOBs J
			join pessoa P with (nolock) on P.apelido = J.[Apelido]	
		where [RUA] is not null and [Pais] is not null
		and [CEP] is not null and [Cidade] is not null
		and [UF] is not null

declare @Temp2 varchar(5000)		
Open C_END
--SET NOCOUNT ON
Fetch Next From C_END Into @cd_pes,@Tipo_Endereco,@Rua,@Numero,@Compl_End,@CEP,@Bairro,@Cidade,@UF,@pais			
	While @@FETCH_STATUS = 0
		Begin			
			set @Temp2 = '[dbo].[spEndereco_InsUpd]' + ''''+ @cd_pes + ''',''' + @Tipo_Endereco 
						+ ''',''' +	@Rua + ''',''' + isnull(@Numero,'NULL') 
						+ ''',''' + isnull(@Compl_End,'NULL') + ''',''' +isnull(@CEP,'NULL') 
						+ ''',''' + isnull(@Bairro,'NULL') + ''',''' + isnull(@Cidade,'NULL')
						+ ''',''' + isnull(@UF,'NULL')+ ''',''' + isnull(@pais,'NULL') + ''''	
			EXEC  (@Temp2)
--			print @Temp2
	
Fetch Next From C_END Into @cd_pes,@Tipo_Endereco,@Rua,@Numero,@Compl_End,@CEP,@Bairro,@Cidade,@UF,@pais		
		End
close C_END
deallocate C_END

GO
