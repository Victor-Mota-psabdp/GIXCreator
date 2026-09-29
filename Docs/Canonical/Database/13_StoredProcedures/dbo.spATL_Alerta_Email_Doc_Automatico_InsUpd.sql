SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--17/03/ 17:58 tirei o DtIns do Update
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_InsUpd]
(
	@ID int,
	@Nome_Task [varchar](30),
	@Grupo [varchar](60),
	@Modal [varchar](2),
	@Dias [float],
	@ResponderPara [varchar](100),
	@Emails [varchar](2500),
	@CopyBDP [varchar](2500),
	@Doc_Anexos [varchar](500),
	@Doc_AnexosNaoObrigatorios	[varchar](500),
	@Mensagem [varchar](2000),
	@Assunto [varchar](200),	
	@Ativo bit,	
	@Email_do_CompanyRegister bit,
	@Email_do_Agente_Consolidado bit,	
	@Nome_Tp_Ocor [varchar](50),
	@JuntaPDF [char](1),	
	@Cd_Usuario [varchar](6),	
	@TypeOFCargo varchar(30),
	@Origem varchar(50),
	@Destino varchar(50),
	@StandardForms varchar(500),
	@OrderType char(1),
	@Cliente [varchar](60),
	@Transportadora [varchar](60),
	@CopyEmail bit,
	@Terminal [varchar](30),
	@Zip bit
	
	--,
	--@ID_N int out
)
AS

--BEGIN TRANSACTION
Declare @Tipo as char(1)
Declare @Cd_Pes_Grupo [varchar](10)
Declare @Cd_Pes [varchar](10)
Declare @cd_org [varchar](10)
Declare @cd_dst [varchar](10)
Declare @Id_Task int
Declare @cd_tp_carga int

Declare @Cd_Transportadora [varchar](10)
Declare @Cd_Terminal [varchar](10)

set @ID = (select top 1 ID from Alerta_Email_Doc_Automatico where Nome_Task = @Nome_Task)
if @ID IS NULL
	Set @ID =((select Isnull(max(ID),0) from Alerta_Email_Doc_Automatico)+1)

if @Grupo <> 'ALL GROUPS'
	set @Cd_Pes_Grupo = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Grupo)
else
	set @Cd_Pes_Grupo ='ALL'

if (@TypeOFCargo = 'ALL Types' or @TypeOFCargo is null)
	set @cd_tp_carga  = 0
else	
	set @cd_tp_carga  = (select cd_tp_carga from tipo_carga where Nome_tp_Carga = @TypeOFCargo)

if @Origem <> 'ALL'
	set @cd_org = (select cd_local from Localidade where Nome_Local =@Origem)
else
	set @cd_org  = 'ALL'

if @Destino <> 'ALL'	
	set @cd_dst = (select cd_local from Localidade where Nome_Local =@Destino)
else
	set @cd_dst  = 'ALL'
	
if @Cliente <> 'ALL Clients'
	set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Cliente)
else
	set @Cd_Pes  = 'ALL'
	
if @Transportadora <> 'ALL Inland Trucker'
	set @Cd_Transportadora = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Transportadora)
else
	set @Cd_Transportadora  = 'ALL'
	
if @Terminal <> 'ALL TERMINALS'
	set @Cd_Terminal = (Select Cd_Terminal from Terminal with(nolock) where Nome_Terminal = @Terminal)
else
	set @Cd_Terminal  = 'ALL'

	
--Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
	declare @tabModal table (Modal varchar(2))
	if @Modal <> 'AL'
		insert @tabModal
			select @Modal
	else
		insert @tabModal
			select distinct modal from tipo_tarefas where Nome_Task = @Nome_Task and Ativo = 'S' 
				and (Cd_Pes_Grupo = @Cd_Pes_Grupo or @Cd_Pes_Grupo = 'ALL' or Cd_Pes_Grupo = '10017')
-------------------------------------------------------------------------
	Declare @Modal_1 varchar(2)
	Declare cTemp cursor for select Modal from @tabModal
	open cTemp
		Fetch Next From cTemp Into @Modal_1
			While @@FETCH_STATUS = 0
				Begin
					If NOT exists (select * from Alerta_Email_Doc_Automatico where [ID] = @Id and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo 
							and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org	and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes
							and cd_transportadora = @Cd_Transportadora and Cd_Terminal = @Cd_Terminal)						
							BEGIN	
								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
								set @Tipo = 'I'
								insert into Alerta_Email_Doc_Automatico
								(
									[ID],[Nome_Task] ,[Id_Task],[Cd_Pes_Grupo],[Modal],[Dias],[ResponderPara],
									[Emails],[Doc_Anexos],[Mensagem],[Ativo],[Nome_Tp_Ocor],[JuntaPDF],	
									[Dt_Ins],[Cd_Usuario],[CopyBDP],[Email_do_CompanyRegister],[cd_tp_carga],
									Cd_Org,Cd_Dst,Assunto,Doc_Anexos_Nao,StandardForms,cd_tp_pedido,
									cd_pes,Email_do_Agente_Consolidado,Cd_transportadora,CopyEmail,Cd_Terminal,Zip
								)
								values
								(			
									@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,
									@Emails,@Doc_Anexos,@Mensagem,@Ativo,@Nome_Tp_Ocor,@JuntaPDF,
									GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,
									@cd_org,@cd_dst,@Assunto,@Doc_AnexosNaoObrigatorios,@StandardForms,@OrderType,@Cd_Pes,
									@Email_do_Agente_Consolidado,@Cd_Transportadora,@CopyEmail,@Cd_Terminal,@Zip
								)
							END
					else
							BEGIN
								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
								set @Tipo = 'A'
								
								UPDATE
									Alerta_Email_Doc_Automatico
								SET
									[Nome_Task] = @Nome_Task,
									[Id_Task] = @Id_Task ,
									--[Cd_Pes_Grupo] = @Cd_Pes_Grupo,
									[Modal] = @Modal_1,
									[Dias] = @Dias,
									[ResponderPara] = @ResponderPara,
									[Emails] = @Emails,
									[Doc_Anexos] = @Doc_Anexos,	
									[Mensagem] = @Mensagem,
									[Ativo] = @Ativo,
									[Nome_Tp_Ocor] = @Nome_Tp_Ocor,
									[JuntaPDF] = @JuntaPDF,
									--[Dt_Ins] = GETDATE(),
									[Cd_Usuario] = @Cd_Usuario,
									[CopyBDP] = @CopyBDP,
									[Email_do_CompanyRegister] = @Email_do_CompanyRegister,
									--cd_tp_carga = @cd_tp_carga
									--Cd_Org = @cd_org,
									--Cd_Dst =@cd_dst,
									Assunto = @Assunto,
									Doc_Anexos_Nao = @Doc_AnexosNaoObrigatorios,
									StandardForms = @StandardForms,
									cd_tp_pedido = @OrderType,
									Email_do_Agente_Consolidado = @Email_do_Agente_Consolidado,
									CopyEmail =@CopyEmail,
									--Cd_transportadora = @Cd_Transportadora
									--cd_pes= @Cd_Pes
									Zip = @Zip
								WHERE
									[ID] = @ID and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo
									and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org
									and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes 
									and Cd_transportadora = @Cd_Transportadora
									and Cd_Terminal = @Cd_Terminal
									
									--set @ID_N = @Id_Task
							END
							
							--LOG
							BEGIN								
								insert into [dbo].[Log_Alerta_Email_Doc_Automatico]
									(Dt_Alter,Tp_Oper,ID,Nome_Task,Id_Task,Cd_Pes_Grupo,Modal,Dias,ResponderPara,Emails,Doc_Anexos,Mensagem,
									Ativo,Nome_Tp_Ocor,JuntaPDF,Dt_Ins,Cd_Usuario,CopyBDP,Email_Do_CompanyRegister,cd_tp_carga,Doc_Anexos_Nao,
									Cd_Org,Cd_Dst,Assunto,StandardForms,cd_tp_pedido,Cd_Pes,Email_do_Agente_Consolidado,
									Cd_Transportadora,CopyEmail,Cd_Terminal,Zip)
								Values
									(getdate(),@Tipo,@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,@Emails,@Doc_Anexos,@Mensagem,
									@Ativo,@Nome_Tp_Ocor,@JuntaPDF,GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,@Doc_AnexosNaoObrigatorios,
									@cd_org,@cd_dst,@Assunto,@StandardForms,@OrderType,@Cd_Pes,@Email_do_Agente_Consolidado,
									@Cd_Transportadora,@CopyEmail,@Cd_Terminal,@Zip)
							END
							
				Fetch Next From cTemp Into @Modal_1
				end
	close cTemp
	deallocate cTemp



--ALTER procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_InsUpd]
--(
--	@ID int,
--	@Nome_Task [varchar](30),
--	@Grupo [varchar](60),
--	@Modal [varchar](2),
--	@Dias [float],
--	@ResponderPara [varchar](100),
--	@Emails [varchar](2500),
--	@CopyBDP [varchar](2500),
--	@Doc_Anexos [varchar](500),
--	@Doc_AnexosNaoObrigatorios	[varchar](500),
--	@Mensagem [varchar](2000),
--	@Assunto [varchar](200),	
--	@Ativo bit,	
--	@Email_do_CompanyRegister bit,
--	@Email_do_Agente_Consolidado bit,	
--	@Nome_Tp_Ocor [varchar](50),
--	@JuntaPDF [char](1),	
--	@Cd_Usuario [varchar](6),	
--	@TypeOFCargo varchar(30),
--	@Origem varchar(50),
--	@Destino varchar(50),
--	@StandardForms varchar(500),
--	@OrderType char(1),
--	@Cliente [varchar](60),
--	@Transportadora [varchar](60),
--	@CopyEmail bit,
--	@Terminal [varchar](30)
	
--	--,
--	--@ID_N int out
--)
--AS

----BEGIN TRANSACTION
--Declare @Tipo as char(1)
--Declare @Cd_Pes_Grupo [varchar](10)
--Declare @Cd_Pes [varchar](10)
--Declare @cd_org [varchar](10)
--Declare @cd_dst [varchar](10)
--Declare @Id_Task int
--Declare @cd_tp_carga int

--Declare @Cd_Transportadora [varchar](10)
--Declare @Cd_Terminal [varchar](10)

--set @ID = (select top 1 ID from Alerta_Email_Doc_Automatico where Nome_Task = @Nome_Task)
--if @ID IS NULL
--	Set @ID =((select Isnull(max(ID),0) from Alerta_Email_Doc_Automatico)+1)

--if @Grupo <> 'ALL GROUPS'
--	set @Cd_Pes_Grupo = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Grupo)
--else
--	set @Cd_Pes_Grupo ='ALL'

--if (@TypeOFCargo = 'ALL Types' or @TypeOFCargo is null)
--	set @cd_tp_carga  = 0
--else	
--	set @cd_tp_carga  = (select cd_tp_carga from tipo_carga where Nome_tp_Carga = @TypeOFCargo)

--if @Origem <> 'ALL'
--	set @cd_org = (select cd_local from Localidade where Nome_Local =@Origem)
--else
--	set @cd_org  = 'ALL'

--if @Destino <> 'ALL'	
--	set @cd_dst = (select cd_local from Localidade where Nome_Local =@Destino)
--else
--	set @cd_dst  = 'ALL'
	
--if @Cliente <> 'ALL Clients'
--	set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Cliente)
--else
--	set @Cd_Pes  = 'ALL'
	
--if @Transportadora <> 'ALL Inland Trucker'
--	set @Cd_Transportadora = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Transportadora)
--else
--	set @Cd_Transportadora  = 'ALL'
	
--if @Terminal <> 'ALL TERMINALS'
--	set @Cd_Terminal = (Select Cd_Terminal from Terminal with(nolock) where Nome_Terminal = @Terminal)
--else
--	set @Cd_Terminal  = 'ALL'

	
----Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
--	declare @tabModal table (Modal varchar(2))
--	if @Modal <> 'AL'
--		insert @tabModal
--			select @Modal
--	else
--		insert @tabModal
--			select distinct modal from tipo_tarefas where Nome_Task = @Nome_Task and Ativo = 'S' 
--				and (Cd_Pes_Grupo = @Cd_Pes_Grupo or @Cd_Pes_Grupo = 'ALL' or Cd_Pes_Grupo = '10017')
---------------------------------------------------------------------------
--	Declare @Modal_1 varchar(2)
--	Declare cTemp cursor for select Modal from @tabModal
--	open cTemp
--		Fetch Next From cTemp Into @Modal_1
--			While @@FETCH_STATUS = 0
--				Begin
--					If NOT exists (select * from Alerta_Email_Doc_Automatico where [ID] = @Id and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo 
--							and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org	and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes
--							and cd_transportadora = @Cd_Transportadora and Cd_Terminal = @Cd_Terminal)						
--							BEGIN	
--								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
--								set @Tipo = 'I'
--								insert into Alerta_Email_Doc_Automatico
--								(
--									[ID],[Nome_Task] ,[Id_Task],[Cd_Pes_Grupo],[Modal],[Dias],[ResponderPara],
--									[Emails],[Doc_Anexos],[Mensagem],[Ativo],[Nome_Tp_Ocor],[JuntaPDF],	
--									[Dt_Ins],[Cd_Usuario],[CopyBDP],[Email_do_CompanyRegister],[cd_tp_carga],
--									Cd_Org,Cd_Dst,Assunto,Doc_Anexos_Nao,StandardForms,cd_tp_pedido,
--									cd_pes,Email_do_Agente_Consolidado,Cd_transportadora,CopyEmail,Cd_Terminal
--								)
--								values
--								(			
--									@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,
--									@Emails,@Doc_Anexos,@Mensagem,@Ativo,@Nome_Tp_Ocor,@JuntaPDF,
--									GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,
--									@cd_org,@cd_dst,@Assunto,@Doc_AnexosNaoObrigatorios,@StandardForms,@OrderType,@Cd_Pes,
--									@Email_do_Agente_Consolidado,@Cd_Transportadora,@CopyEmail,@Cd_Terminal
--								)
--							END
--					else
--							BEGIN
--								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
--								set @Tipo = 'A'
								
--								UPDATE
--									Alerta_Email_Doc_Automatico
--								SET
--									[Nome_Task] = @Nome_Task,
--									[Id_Task] = @Id_Task ,
--									--[Cd_Pes_Grupo] = @Cd_Pes_Grupo,
--									[Modal] = @Modal_1,
--									[Dias] = @Dias,
--									[ResponderPara] = @ResponderPara,
--									[Emails] = @Emails,
--									[Doc_Anexos] = @Doc_Anexos,	
--									[Mensagem] = @Mensagem,
--									[Ativo] = @Ativo,
--									[Nome_Tp_Ocor] = @Nome_Tp_Ocor,
--									[JuntaPDF] = @JuntaPDF,
--									[Dt_Ins] = GETDATE(),
--									[Cd_Usuario] = @Cd_Usuario,
--									[CopyBDP] = @CopyBDP,
--									[Email_do_CompanyRegister] = @Email_do_CompanyRegister,
--									--cd_tp_carga = @cd_tp_carga
--									--Cd_Org = @cd_org,
--									--Cd_Dst =@cd_dst,
--									Assunto = @Assunto,
--									Doc_Anexos_Nao = @Doc_AnexosNaoObrigatorios,
--									StandardForms = @StandardForms,
--									cd_tp_pedido = @OrderType,
--									Email_do_Agente_Consolidado = @Email_do_Agente_Consolidado,
--									CopyEmail =@CopyEmail
--									--Cd_transportadora = @Cd_Transportadora
--									--cd_pes= @Cd_Pes
--								WHERE
--									[ID] = @ID and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo
--									and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org
--									and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes 
--									and Cd_transportadora = @Cd_Transportadora
--									and Cd_Terminal = @Cd_Terminal
									
--									--set @ID_N = @Id_Task
--							END
							
--							--LOG
--							BEGIN								
--								insert into [dbo].[Log_Alerta_Email_Doc_Automatico]
--									(Dt_Alter,Tp_Oper,ID,Nome_Task,Id_Task,Cd_Pes_Grupo,Modal,Dias,ResponderPara,Emails,Doc_Anexos,Mensagem,
--									Ativo,Nome_Tp_Ocor,JuntaPDF,Dt_Ins,Cd_Usuario,CopyBDP,Email_Do_CompanyRegister,cd_tp_carga,Doc_Anexos_Nao,
--									Cd_Org,Cd_Dst,Assunto,StandardForms,cd_tp_pedido,Cd_Pes,Email_do_Agente_Consolidado,
--									Cd_Transportadora,CopyEmail,Cd_Terminal)
--								Values
--									(getdate(),@Tipo,@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,@Emails,@Doc_Anexos,@Mensagem,
--									@Ativo,@Nome_Tp_Ocor,@JuntaPDF,GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,@Doc_AnexosNaoObrigatorios,
--									@cd_org,@cd_dst,@Assunto,@StandardForms,@OrderType,@Cd_Pes,@Email_do_Agente_Consolidado,
--									@Cd_Transportadora,@CopyEmail,@Cd_Terminal)
--							END
							
--				Fetch Next From cTemp Into @Modal_1
--				end
--	close cTemp
--	deallocate cTemp


----XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----ALTER procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_InsUpd]
----(
----	@ID int,
----	@Nome_Task [varchar](30),
----	@Grupo [varchar](60),
----	@Modal [varchar](2),
----	@Dias [float],
----	@ResponderPara [varchar](100),
----	@Emails [varchar](2500),
----	@CopyBDP [varchar](2500),
----	@Doc_Anexos [varchar](100),
----	@Doc_AnexosNaoObrigatorios	[varchar](100),
----	@Mensagem [varchar](2000),
----	@Assunto [varchar](200),	
----	@Ativo bit,	
----	@Email_do_CompanyRegister bit,
----	@Email_do_Agente_Consolidado bit,	
----	@Nome_Tp_Ocor [varchar](50),
----	@JuntaPDF [char](1),	
----	@Cd_Usuario [varchar](6),	
----	@TypeOFCargo varchar(30),
----	@Origem varchar(50),
----	@Destino varchar(50),
----	@StandardForms varchar(500),
----	@OrderType char(1),
----	@Cliente [varchar](60),
----	@Transportadora [varchar](60)
	
	
----	--,
----	--@ID_N int out
----)
----AS

------BEGIN TRANSACTION
----Declare @Tipo as char(1)
----Declare @Cd_Pes_Grupo [varchar](10)
----Declare @Cd_Pes [varchar](10)
----Declare @cd_org [varchar](10)
----Declare @cd_dst [varchar](10)
----Declare @Id_Task int
----Declare @cd_tp_carga int

----Declare @Cd_Transportadora [varchar](10)

----set @Cd_Pes_Grupo = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Grupo)

------set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal)

----if (@TypeOFCargo = 'ALL Types' or @TypeOFCargo is null)
----	set @cd_tp_carga  = 0
----else	
----	set @cd_tp_carga  = (select cd_tp_carga from tipo_carga where Nome_tp_Carga = @TypeOFCargo)

----if @Origem <> 'ALL'
----	set @cd_org = (select cd_local from Localidade where Nome_Local =@Origem)
----else
----	set @cd_org  = 'ALL'

----if @Destino <> 'ALL'	
----	set @cd_dst = (select cd_local from Localidade where Nome_Local =@Destino)
----else
----	set @cd_dst  = 'ALL'
	
----if @Cliente <> 'ALL Clients'
----	set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Cliente)
----else
----	set @Cd_Pes  = 'ALL'
	
----if @Transportadora <> 'ALL Inland Trucker'
----	set @Cd_Transportadora = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Transportadora)
----else
----	set @Cd_Transportadora  = 'ALL'

	
------Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
----	declare @tabModal table (Modal varchar(2))
----	if @Modal <> 'AL'
----		insert @tabModal
----			select @Modal
----	else
----		insert @tabModal
----			select distinct modal from tipo_tarefas where Nome_Task = @Nome_Task and Ativo = 'S' 
----				and (Cd_Pes_Grupo = @Cd_Pes_Grupo or Cd_Pes_Grupo = '10017')
-----------------------------------------------------------------------------
----	Declare @Modal_1 varchar(2)
----	Declare cTemp cursor for select Modal from @tabModal
----	open cTemp
----		Fetch Next From cTemp Into @Modal_1
----			While @@FETCH_STATUS = 0
----				Begin
----					If NOT exists (select ID from Alerta_Email_Doc_Automatico where [ID] = @Id and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo 
----							and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org	and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes
----							and cd_transportadora = @Cd_Transportadora)						
----							BEGIN	
----								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
----								set @Tipo = 'I'
----								insert into Alerta_Email_Doc_Automatico
----								(
----									[ID],[Nome_Task] ,[Id_Task],[Cd_Pes_Grupo],[Modal],[Dias],[ResponderPara],
----									[Emails],[Doc_Anexos],[Mensagem],[Ativo],[Nome_Tp_Ocor],[JuntaPDF],	
----									[Dt_Ins],[Cd_Usuario],[CopyBDP],[Email_do_CompanyRegister],[cd_tp_carga],
----									Cd_Org,Cd_Dst,Assunto,Doc_Anexos_Nao,StandardForms,cd_tp_pedido,
----									cd_pes,Email_do_Agente_Consolidado,Cd_transportadora
----								)
----								values
----								(			
----									@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,
----									@Emails,@Doc_Anexos,@Mensagem,@Ativo,@Nome_Tp_Ocor,@JuntaPDF,
----									GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,
----									@cd_org,@cd_dst,@Assunto,@Doc_AnexosNaoObrigatorios,@StandardForms,@OrderType,@Cd_Pes,
----									@Email_do_Agente_Consolidado,@Cd_Transportadora
----								)
----							END
----					else
----							BEGIN
----								set @Id_Task = (Select top 1 id_task from Tipo_Tarefas with(nolock) where Nome_Task = @Nome_Task and Modal = @Modal_1 and Ativo = 'S')
----								set @Tipo = 'A'
								
----								UPDATE
----									Alerta_Email_Doc_Automatico
----								SET
----									[Nome_Task] = @Nome_Task,
----									[Id_Task] = @Id_Task ,
----									--[Cd_Pes_Grupo] = @Cd_Pes_Grupo,
----									[Modal] = @Modal_1,
----									[Dias] = @Dias,
----									[ResponderPara] = @ResponderPara,
----									[Emails] = @Emails,
----									[Doc_Anexos] = @Doc_Anexos,	
----									[Mensagem] = @Mensagem,
----									[Ativo] = @Ativo,
----									[Nome_Tp_Ocor] = @Nome_Tp_Ocor,
----									[JuntaPDF] = @JuntaPDF,
----									[Dt_Ins] = GETDATE(),
----									[Cd_Usuario] = @Cd_Usuario,
----									[CopyBDP] = @CopyBDP,
----									[Email_do_CompanyRegister] = @Email_do_CompanyRegister,
----									--cd_tp_carga = @cd_tp_carga
----									--Cd_Org = @cd_org,
----									--Cd_Dst =@cd_dst,
----									Assunto = @Assunto,
----									Doc_Anexos_Nao = @Doc_AnexosNaoObrigatorios,
----									StandardForms = @StandardForms,
----									cd_tp_pedido = @OrderType,
----									Email_do_Agente_Consolidado = @Email_do_Agente_Consolidado
----									--Cd_transportadora = @Cd_Transportadora
----									--cd_pes= @Cd_Pes
----								WHERE
----									[ID] = @ID and [Modal]=@Modal_1 and [Cd_Pes_Grupo] = @Cd_Pes_Grupo
----									and cd_tp_carga = @cd_tp_carga and Cd_Org = @cd_org
----									and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes 
----									and Cd_transportadora = @Cd_Transportadora
									
----									--set @ID_N = @Id_Task
----							END
							
----							--LOG
----							BEGIN								
----								insert into [dbo].[Log_Alerta_Email_Doc_Automatico]
----									(Dt_Alter,Tp_Oper,ID,Nome_Task,Id_Task,Cd_Pes_Grupo,Modal,Dias,ResponderPara,Emails,Doc_Anexos,Mensagem,
----									Ativo,Nome_Tp_Ocor,JuntaPDF,Dt_Ins,Cd_Usuario,CopyBDP,Email_Do_CompanyRegister,cd_tp_carga,Doc_Anexos_Nao,
----									Cd_Org,Cd_Dst,Assunto,StandardForms,cd_tp_pedido,Cd_Pes,Email_do_Agente_Consolidado,
----									Cd_Transportadora)
----								Values
----									(getdate(),@Tipo,@ID,@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal_1,@Dias,@ResponderPara,@Emails,@Doc_Anexos,@Mensagem,
----									@Ativo,@Nome_Tp_Ocor,@JuntaPDF,GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,@Doc_AnexosNaoObrigatorios,
----									@cd_org,@cd_dst,@Assunto,@StandardForms,@OrderType,@Cd_Pes,@Email_do_Agente_Consolidado,
----									@Cd_Transportadora)
----							END
							
----				Fetch Next From cTemp Into @Modal_1
----				end
----	close cTemp
----	deallocate cTemp
						
	
	
----	If  exists (select ID from Alerta_Email_Doc_Automatico where ID=@ID)
----		BEGIN
----			UPDATE
----				Alerta_Email_Doc_Automatico
----			SET
----				[Nome_Task] = @Nome_Task,
----				[Id_Task] = @Id_Task ,
----				[Cd_Pes_Grupo] = @Cd_Pes_Grupo,
----				[Modal] = @Modal,
----				[Dias] = @Dias,
----				[ResponderPara] = @ResponderPara,
----				[Emails] = @Emails,
----				[Doc_Anexos] = @Doc_Anexos,	
----				[Mensagem] = @Mensagem,
----				[Ativo] = @Ativo,
----				[Nome_Tp_Ocor] = @Nome_Tp_Ocor,
----				[JuntaPDF] = @JuntaPDF,
----				[Dt_Ins] = GETDATE(),
----				[Cd_Usuario] = @Cd_Usuario
----			WHERE
----				ID = @ID
				
----				set @ID_N = @ID
----		END
----	ELSE
----		BEGIN	
----			insert into 
----				Alerta_Email_Doc_Automatico
----				(
----					[Nome_Task] ,
----					[Id_Task],
----					[Cd_Pes_Grupo],
----					[Modal],
----					[Dias],
----					[ResponderPara],
----					[Emails],
----					[Doc_Anexos],	
----					[Mensagem],	
----					[Ativo],	
----					[Nome_Tp_Ocor],
----					[JuntaPDF],	
----					[Dt_Ins],
----					[Cd_Usuario]
----				)
----			values
----				(			
----					@Nome_Task,
----					@Id_Task ,
----					@Cd_Pes_Grupo,
----					@Modal,
----					@Dias,
----					@ResponderPara,
----					@Emails,
----					@Doc_Anexos,	
----					@Mensagem,	
----					1,	
----					@Nome_Tp_Ocor,
----					@JuntaPDF,
----					GETDATE(),	
----					@Cd_Usuario
----				)
				
----				set @ID_N = (select ID from Alerta_Email_Doc_Automatico where 
----					[Modal]=@Modal and [ID_Task] = @Id_Task  and [Cd_Pes_Grupo] = @Cd_Pes_Grupo)
----		END

----IF @@Error <> 0
----	Begin
----		ROLLBACK TRANSACTION
----		RETURN -1
----	End

----COMMIT TRANSACTION

GO
