SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMEM_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
	@Master		VarChar(14),
	@Job		varchar(16)
AS

Begin Transaction
		--IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Master)
		--	BEGIN
		--		RETURN -2
		--	END
	Declare @Viagem			VarChar(10)
	Declare @Cd_Org_HEM 	VarChar(10)
	Declare @Navio			VarChar(50)

	If UPPER(@Master) = 'JOB'
		Begin
		--Tabela House_Exp_Mar
			Update
				House_Exp_Mar
			Set
				Num_Proc_MEM = 'JOB'
			Where
				Num_Proc_HEM = @Job
		End
	ELSE
		Begin
		--Tabela House_Exp_Mar
			Update
				House_Exp_Mar
			Set
				Num_Proc_MEM = @Master,
				Cd_Org_HEM	 =(select Cd_Org_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
				Cd_Dst_HEM	 =(select Cd_Dst_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
				Viagem_HEM	 =(select Num_Viagem from LLP_Master where Num_Proc_Master=@Master),
				Navio_HEM	 =(select Navio from LLP_Master where Num_Proc_Master=@Master),
				MAWB_HEM	 =(select MAWB_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master)
			Where
				Num_Proc_HEM = @Job

		--Tabela LLP_Exp_Mar
			Update
				LLP_Exp_Mar
			Set
				ETD_LEM = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
				ATD_LEM = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
				ETA_LEM = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
				ATA_LEM = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master)
--Desabilitado em 13-6-2011 ocomon 13044
--				Cd_Armador_LEM = (select Cd_Carrier from LLP_Master where Num_Proc_Master=@Master)
				--Incluso 04-09-2012 - Status do Processo
				--Excluido 21/10/2022 - Cadu 100-338956
				--,ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)
			Where
				Num_Proc_LEM = @Job
				
				
				
		--Update pra Navio X Viagem
		Begin
			set @cd_org_HEM = (select Cd_Org_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master)
			set @Viagem  = (select Num_Viagem from LLP_Master where Num_Proc_Master=@Master)
			set @Navio  = (select Navio from LLP_Master where Num_Proc_Master=@Master)
	
			update LLP_Exp_Mar set id_viagem = (
				select V.ID_Viagem from viagem_llp V
					join Navio_LLP N on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @Cd_Org_HEM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'E')  
				where Num_Proc_Lem = @Job 
		End	
				
		End

--Tabela Container_Mas_Exp_Mar
	--Guardar o número do Master Anterior
	declare @Master_Del as VarChar(14)
	set @Master_Del	=
		(
		SELECT top 1 MAS.Num_Proc_MEM from Container_Mas_Exp_Mar MAS
		Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
		where num_proc_HEM=@Job
		)
	if @Master_Del <> @Master
		Begin
			insert into Container_Mas_Exp_Mar
			SELECT @Master,MAS.Item_Cont_EM,Cd_Tp_Cont,Num_Cont_EM,Num_Lacre_EM,Lacre_02_EM,Lacre_03_EM,Lacre_04_EM,
				Peso_Bruto_EM,VolumeM3,ID_ISO,Tara_EM ,[Temperature],[Vent_Status],[Battery_Time],[Cd_Tp_Volt],[Graus],
				Dt_Vcto_Devol_EM,Dt_Est_Devol_EM ,Peso_Liquido_EM
			from Container_Mas_Exp_Mar MAS
			Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
			where num_proc_HEM=@Job
			--update Container_Hou_Exp_Mar set num_proc_MEM=@Master
			--where num_proc_HEM=@Job
			--delete Container_Mas_Exp_Mar
			--where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_HEM=@Job)
						
			Insert container_hou_exp_mar
			select @Master,item_cont_em,@job from container_hou_exp_mar where num_proc_hem=@Job

			delete Container_hou_exp_mar
			where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_hem=@Job)

			delete Container_Mas_Exp_Mar
			where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_hem=@Job)
		
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction


/*
ALTER PROCEDURE [dbo].[spMEM_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
	@Master		VarChar(14),
	@Job		varchar(16)
AS

Begin Transaction
		--IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Master)
		--	BEGIN
		--		RETURN -2
		--	END

	If UPPER(@Master) = 'JOB'
		Begin
		--Tabela House_Exp_Mar
			Update
				House_Exp_Mar
			Set
				Num_Proc_MEM = 'JOB'
			Where
				Num_Proc_HEM = @Job
		End
	ELSE
		Begin
		--Tabela House_Exp_Mar
			Update
				House_Exp_Mar
			Set
				Num_Proc_MEM = @Master,
				Cd_Org_HEM	 =(select Cd_Org_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
				Cd_Dst_HEM	 =(select Cd_Dst_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
				Viagem_HEM	 =(select Num_Viagem from LLP_Master where Num_Proc_Master=@Master),
				Navio_HEM	 =(select Navio from LLP_Master where Num_Proc_Master=@Master),
				MAWB_HEM	 =(select MAWB_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master)
			Where
				Num_Proc_HEM = @Job

		--Tabela LLP_Exp_Mar
			Update
				LLP_Exp_Mar
			Set
				ETD_LEM = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
				ATD_LEM = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
				ETA_LEM = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
				ATA_LEM = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master),
--Desabilitado em 13-6-2011 ocomon 13044
--				Cd_Armador_LEM = (select Cd_Carrier from LLP_Master where Num_Proc_Master=@Master)
				--Incluso 04-09-2012 - Status do Processo
				ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)
			Where
				Num_Proc_LEM = @Job
		End

--Tabela Container_Mas_Exp_Mar
	--Guardar o número do Master Anterior
	declare @Master_Del as VarChar(14)
	set @Master_Del	=
		(
		SELECT top 1 MAS.Num_Proc_MEM from Container_Mas_Exp_Mar MAS
		Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
		where num_proc_HEM=@Job
		)
	if @Master_Del <> @Master
		Begin
			insert into Container_Mas_Exp_Mar
			SELECT @Master,MAS.Item_Cont_EM,Cd_Tp_Cont,Num_Cont_EM,Num_Lacre_EM,Lacre_02_EM,Lacre_03_EM,Lacre_04_EM,
				Peso_Bruto_EM,VolumeM3,ID_ISO,Tara_EM ,[Temperature],[Vent_Status],[Battery_Time],[Cd_Tp_Volt],[Graus],
				Dt_Vcto_Devol_EM,Dt_Est_Devol_EM ,Peso_Liquido_EM
			from Container_Mas_Exp_Mar MAS
			Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
			where num_proc_HEM=@Job
			--update Container_Hou_Exp_Mar set num_proc_MEM=@Master
			--where num_proc_HEM=@Job
			--delete Container_Mas_Exp_Mar
			--where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_HEM=@Job)
						
			Insert container_hou_exp_mar
			select @Master,item_cont_em,@job from container_hou_exp_mar where num_proc_hem=@Job

			delete Container_hou_exp_mar
			where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_hem=@Job)

			delete Container_Mas_Exp_Mar
			where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_hem=@Job)
		
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction
*/


--ALTER PROCEDURE [dbo].[spMEM_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
--	@Master		VarChar(14),
--	@Job		varchar(16)
--AS

--Begin Transaction
--	If UPPER(@Master) = 'JOB'
--		Begin
--		--Tabela House_Exp_Mar
--			Update
--				House_Exp_Mar
--			Set
--				Num_Proc_MEM = 'JOB'
--			Where
--				Num_Proc_HEM = @Job
--		End
--	ELSE
--		Begin
--		--Tabela House_Exp_Mar
--			Update
--				House_Exp_Mar
--			Set
--				Num_Proc_MEM = @Master,
--				Cd_Org_HEM	 =(select Cd_Org_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
--				Cd_Dst_HEM	 =(select Cd_Dst_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master),
--				Viagem_HEM	 =(select Num_Viagem from LLP_Master where Num_Proc_Master=@Master),
--				Navio_HEM	 =(select Navio from LLP_Master where Num_Proc_Master=@Master),
--				MAWB_HEM	 =(select MAWB_MEM from Master_Exp_Mar where Num_Proc_MEM=@Master)
--			Where
--				Num_Proc_HEM = @Job

--		--Tabela LLP_Exp_Mar
--			Update
--				LLP_Exp_Mar
--			Set
--				ETD_LEM = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
--				ATD_LEM = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
--				ETA_LEM = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
--				ATA_LEM = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master),
----Desabilitado em 13-6-2011 ocomon 13044
----				Cd_Armador_LEM = (select Cd_Carrier from LLP_Master where Num_Proc_Master=@Master)
--				--Incluso 04-09-2012 - Status do Processo
--				ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)
--			Where
--				Num_Proc_LEM = @Job
--		End

----Tabela Container_Mas_Exp_Mar
--	--Guardar o número do Master Anterior
--	declare @Master_Del as VarChar(14)
--	set @Master_Del	=
--		(
--		SELECT top 1 MAS.Num_Proc_MEM from Container_Mas_Exp_Mar MAS
--		Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
--		where num_proc_HEM=@Job
--		)
--	if @Master_Del <> @Master
--		Begin
--			insert into Container_Mas_Exp_Mar
--			SELECT @Master,MAS.Item_Cont_EM,Cd_Tp_Cont,Num_Cont_EM,Num_Lacre_EM,Lacre_02_EM,Lacre_03_EM,Lacre_04_EM,Peso_Bruto_EM,VolumeM3,ID_ISO,Tara_EM from Container_Mas_Exp_Mar MAS
--			Left Outer Join Container_Hou_Exp_Mar HOU on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
--			where num_proc_HEM=@Job

--			update Container_Hou_Exp_Mar set num_proc_MEM=@Master
--			where num_proc_HEM=@Job

--			delete Container_Mas_Exp_Mar
--			where Num_Proc_MEM = @Master_Del and Item_Cont_EM in (select Item_Cont_EM from Container_Hou_Exp_Mar where num_proc_HEM=@Job)
--		End

--	IF @@Error <> 0
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END

--Commit Transaction
GO
