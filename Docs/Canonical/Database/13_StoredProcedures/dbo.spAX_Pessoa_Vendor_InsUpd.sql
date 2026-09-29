SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAX_Pessoa_Vendor_InsUpd]

as

	Declare @cd_pes			varchar(10)
	Declare @CNPJ			Varchar(15)
	Declare @Apelido		varchar(20)
	Declare	@Nome_raz_Soc	varchar(60)	
	Declare	@num_cpf_cnpj	varchar(50)	
	Declare	@cd_tp_Ativ		varchar(3)
	Declare	@Cd_Tp_Grupo	varchar(3)
	Declare	@Cd_Usuario		varchar(15)
	Declare	@Dt_Cad			char(10)
	Declare	@Desat_Pes		char(1)
	Declare	@Obs_Pes		varchar(200)
	Declare	@Num_RG_IE		varchar(16)
	Declare	@Num_Insc_Munic	varchar(20)
	Declare	@AccountNum		varchar(50)

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
	
	--Grupo
	Declare @grupo			varchar(50)
	
	Declare @Temp			varchar(2000)
	
	Declare @JOBs Table 
			(
			[cd_pes]		varchar(50),
			[Apelido]		varchar(20),
			[Nome_raz_Soc]	varchar(60),	
			[num_cpf_cnpj]	varchar(50),	
			[cd_tp_Ativ]	varchar(3),
			[Cd_Tp_Grupo]	varchar(3),
			[Cd_Usuario]	 varchar(15),
			[Dt_Cad]		char(10),
			[Desat_Pes]		char(1),
			[Obs_Pes]		varchar(200),
			[Num_RG_IE]		varchar(16),
			[Num_Insc_Munic] varchar(20),
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
			[Pais]			varchar(50),
			
			--Grupo
			[Grupo]			varchar(50)					
			)
	Begin
		Insert into @JOBs			
			select 
				Ax.YourAccountNum								[cd_pes],
--				[dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(NameAlias)))	[Apelido],
				left([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(NameAlias))),16 - Len(AccountNum + 'V')) + ' - ' + AccountNum + 'V' [Apelido],
				left([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(Name))),60)		[Nome_raz_Soc],
				replace(replace(replace(CNPJCPFNum,'.',''),'-',''),'/','')	[Num_CPF_CNPJ],				
				'GRL'								[cd_tp_Ativ],
				'GRL'								[Cd_Tp_Grupo],
				'ATL'								[cd_usuario],
				convert(varchar(10),getdate(),103)	[Dt_Cad],
				'N'									[Desat_Pes],
				'Integração Dynamics AX - Vend - AccountNUM = ' + AccountNum [Obs_Pes],
				(replace(iENUM,'.',''))				[Num_Rg_IE],
				Null								[Num_Insc_Munic],
				AccountNum							[AccountNum],	
				--endereco
				'Comercial'									[Tipo_Endereco],
				isnull(left(Street3,40),isnull(left(Street4,40),left(Street6,40)))	[Rua],
				isnull(addressNumber4,isnull(addressNumber3,addressNumber6))		[Numero],
				isnull(AddressComplement,isnull(AddressComplement4,isnull(AddressComplement3,AddressComplement6)))[Compl_End],
				isnull(ZipCode3,isnull(ZipCode4,ZipCode6))					[CEP],
				isnull(DistrictName,DistrictName4)						[Bairro],
				isnull(City4,isnull(City3,isnull(City,City6)))			[Cidade],
				isnull(State3,isnull(state4,state6))						[UF],
				isnull(PA.Nome_pais,isnull(P3.nome_pais,isnull(P4.nome_pais,P6.nome_pais)))	[Pais],
				AX.Dimensao3		[Grupo]		
			from ax_xml_vendor_recebido AX with (nolock)
				left join PAIS PA with (nolock) on PA.cd_pais = AX.CountryRegionID
				left join PAIS P3 with (nolock) on P3.cd_pais = AX.CountryRegionID3
				left join PAIS P4 with (nolock) on P4.cd_pais = AX.CountryRegionID4
				left join PAIS P6 with (nolock) on P6.cd_pais = AX.CountryRegionID6							
			where 
				Dt_Atualiza_ATL is null
				--and accountNUm = 1521
				--and AX.Dimensao3 <> ''
				and VendGroup <> 'Not'		
	End

Declare C_JOBs cursor for

--Busca Numeros do JOB conforme datas Informadas 
		Select [cd_pes],[Num_CPF_CNPJ],[Apelido] from @JOBs
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @cd_pes,@CNPJ,@Apelido
	While @@FETCH_STATUS = 0
		Begin
--				if @cd_pes is null
--					begin
--						if exists(select top 1 cd_pes from pessoa with (nolock) where Num_cpf_cnpj=@CNPJ)
--							begin								
--								SET @Cd_Pes = (select top 1 cd_pes from pessoa with (nolock) where Num_cpf_cnpj=@CNPJ)
--								update @JOBs set [cd_pes]  = @cd_PEs
--								where [Num_CPF_CNPJ]=@CNPJ
--								
--							end 
--					end
--				else
--					begin														
--						SET @Cd_Pes = (select cd_pes from pessoa with (nolock) where cd_pes=@cd_pes)
--						update @JOBs set [cd_pes]  = @cd_Pes
--						where [cd_pes]=@cd_pes						
--					end
--				if @cd_pes is null
					set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)
					set @cd_tp_Ativ = (Select Cd_Tp_Ativ from Pessoa with(nolock) where Apelido = @Apelido)
					set @Desat_Pes = (Select Desat_Pes from Pessoa with(nolock) where Apelido = @Apelido)
					set @Cd_Tp_Grupo = (Select Cd_Tp_Grupo from Pessoa with(nolock) where Apelido = @Apelido)

					update 
						@JOBs 
					set 
						[cd_pes]  = @cd_Pes,
						[Cd_Tp_Ativ] = isnull(@Cd_Tp_Ativ,'GRL'),
						[Desat_Pes] =ISNULL( @Desat_Pes,'N'),
						[Cd_Tp_Grupo] = ISNULL(@Cd_Tp_Grupo,'GRL')
					where 
						[Apelido]=@Apelido
					
			Fetch Next From C_JOBS Into @cd_pes, @CNPJ,@Apelido
		End
close C_JOBS
deallocate C_JOBS
---Guarda na tabela temporaria
Declare C_INS cursor for
--
		Select  [cd_pes],[Num_CPF_CNPJ],[Apelido],[Nome_raz_Soc],
				[cd_tp_Ativ],[Cd_Tp_Grupo],[cd_usuario],[Dt_Cad],
				[Desat_Pes],[Obs_Pes],[Num_Rg_IE],[Num_Insc_Munic],
				[AccountNum]
		from @JOBs
declare @Temp1 varchar(5000)		
Open C_INS
--SET NOCOUNT ON
Fetch Next From C_INS Into @cd_pes,@CNPJ,@Apelido,@Nome_raz_Soc,
							@cd_tp_Ativ,@Cd_Tp_Grupo,@Cd_Usuario,@Dt_Cad,
							@Desat_Pes,@Obs_Pes,@Num_RG_IE,@Num_Insc_Munic,
							@AccountNum			
	While @@FETCH_STATUS = 0
		Begin			
			set @Temp1 = 'dbo.[spATL_Pessoa_InsUpd]' + ''''+isnull(@cd_pes,'') + ''',''' + @Apelido 
						+ ''',''' +	@Nome_raz_Soc + ''',''' + isnull(@CNPJ,'') 
						+ ''',''' + @cd_tp_Ativ + ''',''' + @Cd_Tp_Grupo 
						+ ''',''' +@Cd_Usuario 	+ ''',''' + @Dt_Cad 
						+ ''',''' + @Desat_Pes + ''',''' + @Obs_Pes 
						+ ''',''' + isnull(@Num_RG_IE,'') + ''',''' + isnull(@Num_Insc_Munic,'')+ ''''
		
--			print (@Temp1)
			EXEC  (@Temp1)			

		Begin
			update ax_xml_vendor_recebido set Dt_Atualiza_ATL = getdate() where accountNum = @AccountNum	
		End		
Fetch Next From C_INS Into @cd_pes,@CNPJ,@Apelido,@Nome_raz_Soc,
							@cd_tp_Ativ,@Cd_Tp_Grupo,@Cd_Usuario,@Dt_Cad,
							@Desat_Pes,@Obs_Pes,@Num_RG_IE,@Num_Insc_Munic,
							@AccountNum	
		End
close C_INS
deallocate C_INS

--Endereco
Declare C_END cursor for
--
		Select P.cd_pes,[Tipo_Endereco],[Rua],[Numero],[dbo].[FRemoveCaracteresEspeciais]([Compl_End]),
		[CEP],[Bairro],[Cidade],[UF],[Pais]
		from @JOBs J
			left join pessoa P with (nolock) on P.apelido = J.[Apelido]	
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

--			print (@Temp2)	
			EXEC  (@Temp2)
	
Fetch Next From C_END Into @cd_pes,@Tipo_Endereco,@Rua,@Numero,@Compl_End,@CEP,@Bairro,@Cidade,@UF,@pais		
		End
close C_END
deallocate C_END


----Grupo
--Declare C_GRU cursor for
----
--		Select P.cd_pes,G.cd_pes_grupo
--		from @JOBs J
--			join pessoa P with (nolock) on P.apelido = J.[Apelido]
--			join Grupo G with (nolock) on G.AX_Grupo = J.[Grupo]					
--		where 
--			J.[Grupo] is not null and P.cd_pes is not null
--			and G.AX_Grupo <> 'ROHM'

--declare @Temp3 varchar(5000)		
--Open C_GRU
----SET NOCOUNT ON
--Fetch Next From C_GRU Into @cd_pes,@Grupo
--	While @@FETCH_STATUS = 0
--		Begin			
--			set @Temp3 = '[dbo].[spATL_Grupo_InsUpd]' + ''''+ @cd_pes + ''',''' + @Grupo 
--						+ ''',''' +	'' + ''',''' + '' + ''''	
--			EXEC  (@Temp3)
--			--print @Temp3
	
--Fetch Next From C_GRU Into @cd_pes,@Grupo		
--		End
--close C_GRU
--deallocate C_GRU


GO
