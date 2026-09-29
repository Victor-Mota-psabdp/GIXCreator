SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from AX_XML_Vendor_Recebido where accountNUm = 1202 

CREATE procedure [dbo].[spAX_Endereco_Vendor_InsUpd]

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
			[Rua]			varchar(50),
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
				Ax.YourAccountNum					[cd_pes],
--				NameAlias							[Apelido],
				[dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(NameAlias)))	[Apelido],			
				AccountNum							[AccountNum],
				--endereco
				'Comercial'									[Tipo_Endereco],
				isnull(left(Street3,40),left(Street4,40))	[Rua],
				isnull(addressNumber4,addressNumber3)		[Numero],
				isnull(AddressComplement,isnull(AddressComplement4,AddressComplement3))[Compl_End],
				isnull(ZipCode3,ZipCode4)					[CEP],
				isnull(DistrictName,DistrictName4)			[Bairro],
				isnull(City4,isnull(City3,City))				[Cidade],
				isnull(State3,state4)						[UF],
				isnull(PA.Nome_pais,isnull(P3.nome_pais,P4.nome_pais))	[Pais]	
			from ax_xml_vendor_recebido AX with (nolock)
				left join PAIS PA with (nolock) on PA.cd_pais = AX.CountryRegionID
				left join PAIS P3 with (nolock) on P3.cd_pais = AX.CountryRegionID3
				left join PAIS P4 with (nolock) on P4.cd_pais = AX.CountryRegionID4
--				where 
--				Dt_Atualiza_ATL is null
--				accountNUm = 1199 	
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
						+ ''',''' +	@Rua + ''',''' + isnull(@Numero,'') 
						+ ''',''' + isnull(@Compl_End,'') + ''',''' +isnull(replace(@CEP,'-',''),'') 
						+ ''',''' + isnull(@Bairro,'') + ''',''' + isnull(@Cidade,'')
						+ ''',''' + isnull(@UF,'')+ ''',''' + isnull(@pais,'') + ''''	
			EXEC  (@Temp2)
--			print @Temp2
	
Fetch Next From C_END Into @cd_pes,@Tipo_Endereco,@Rua,@Numero,@Compl_End,@CEP,@Bairro,@Cidade,@UF,@pais		
		End
close C_END
deallocate C_END

GO
