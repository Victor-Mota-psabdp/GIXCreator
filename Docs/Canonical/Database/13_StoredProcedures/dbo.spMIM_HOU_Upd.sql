SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMIM_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
	@Master		VarChar(14),
	@Job		varchar(16)
AS

Begin Transaction

		--IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Master)
		--	BEGIN
		--		RETURN -2
		--	END

	Declare @Viagem			VarChar(10)
	Declare @cd_dst_HIM 	VarChar(10)
	Declare @Navio			VarChar(50)

	If UPPER(@Master) = 'JOB'
		Begin
		--Tabela House_Imp_Mar
			Update
				House_Imp_Mar
			Set
				Num_Proc_MIM = 'JOB'
			Where
				Num_Proc_HIM = @Job
		End
	ELSE
		Begin

		--Tabela Master_Imp_Mar
			Update
				Master_Imp_Mar
			Set
				Dt_Atrac_MIM = convert(char(10),(select ATA_Master from LLP_Master where Num_Proc_Master=@Master),103)
			Where
				Num_Proc_MIM = @Master

		--Tabela House_Imp_Mar
			Update
				House_Imp_Mar
			Set
				Num_Proc_MIM = @Master,
				Cd_Org_HIM	 =(select Cd_Org_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master),
				Cd_Dst_HIM	 =(select Cd_Dst_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master),
				Viagem_HIM	 =(select Viagem_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master),
				Navio_HIM	 =(select Navio_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master),
				MAWB_HIM	 =(select MAWB_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master)
			Where
				Num_Proc_HIM = @Job

		--Tabela Job_Imp_Mar
--Desabilitado em 13-6-2011 ocomon 13044
--			Update
--				Job_Imp_Mar
--			Set
--				Cd_Armador	 =(select Cd_Armador from Master_Imp_Mar where Num_Proc_MIM=@Master)
--			Where
--				Num_Proc_HIM = @Job

		--Tabela LLP_Imp_Mar
			Update
				LLP_Imp_Mar
			Set
				ETD_LIM = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
				ATD_LIM = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
				ETA_LIM = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
				ATA_LIM = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master)
				--Incluso 31-08-2012 - Status do Processo
				--Excluido 21/10/2022 - Cadu 100-338956
				--,ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)
			Where
				Num_Proc_LIM = @Job
			
			
		--Update pra Navio X Viagem
		Begin
			set @cd_dst_HIM = (select Cd_Dst_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master)
			set @Viagem  = (select Viagem_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master)
			set @Navio  = (select Navio_MIM from Master_Imp_Mar where Num_Proc_MIM=@Master)
		End
		
		
		Begin
			update LLP_Imp_Mar set id_viagem = (
				select V.ID_Viagem from viagem_llp V
					join Navio_LLP N on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @cd_dst_HIM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'I') 
				where Num_Proc_Lim = @Job 
		End
			
		--Tabela PO_HIM
			exec dbo.spAtualiza_PO_Modais @Master

		--Tabela Cta_Cte_hou_imp_XXX
		--100-67340--Solicitação de desativação.
			--exec spFreteAuto_Ins @Master , @Job

		End
		--


--Tabela Container_Mas_Imp_Mar
	--Guardar o número do Master Anterior
	declare @Master_Del as VarChar(14)
	set @Master_Del	=
		(
		SELECT top 1 MAS.Num_Proc_MIM from Container_Mas_Imp_Mar MAS
		Left Outer Join Container_Hou_Imp_Mar HOU on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		where num_proc_him=@Job
		)
	
	if @Master_Del <> @Master
		Begin		
			
			insert into Container_Mas_Imp_Mar

			SELECT @Master,MAS.Item_Cont_IM,Cd_Tp_Cont,Num_Cont_IM,Num_Lacre_IM,Dt_Vcto_Devol_IM,Dt_Devol_IM,Lacre_02_IM,
			Lacre_03_IM,Lacre_04_IM,Peso_Bruto_IM,VolumeM3,ID_ISO,Tara_IM,DataDevCli_IM,inspecao ,dt_ins 
			from Container_Mas_Imp_Mar MAS
			Left Outer Join Container_Hou_Imp_Mar HOU on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
			where num_proc_him=@Job		

			Insert container_hou_imp_mar
			select @master,item_cont_im,@job from container_hou_imp_mar where num_proc_him=@Job

			delete Container_hou_imp_mar
			where Num_Proc_MIM = @Master_Del and Item_Cont_IM in (select Item_Cont_IM from Container_Hou_Imp_Mar where num_proc_him=@Job)


			delete Container_Mas_Imp_Mar
			where Num_Proc_MIM = @Master_Del and Item_Cont_IM in (select Item_Cont_IM from Container_Hou_Imp_Mar where num_proc_him=@Job)
		
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction





GO
