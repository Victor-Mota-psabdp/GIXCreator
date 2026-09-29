SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spExchange_E_AirFreight_InsUpd]

	@Num_Proc	varchar(16),
	@Num_Master varchar(14)

as


--Declare @Cd_Usuario varchar(6)

if @Num_Proc is not null and @Num_Master is null

	--set @Cd_Usuario = (Select top 1 Cd_Usuario from vwHouse_Exp where Num_Proc = @Num_Proc)

	If  exists (select Num_Proc_Hea from Exchange_E_AirFreight where Num_Proc_Hea = @Num_Proc)
		Begin
			Update
				Exchange_E_AirFreight
			Set
				Num_Proc_Hea_Dt_Envio = Null,
				Num_Proc_Hea_Dt_Ins = Getdate()
			Where
				Num_Proc_Hea = @Num_Proc	                        
		End
	Else
		Begin	
			Insert
				  Exchange_E_AirFreight
			--	  (Num_Proc_Mea,Num_Proc_Hea,Num_Proc_Mea_Dt_Ins,Num_Proc_Mea_Dt_Envio,Num_Proc_Hea_Dt_Envio)
			--Values			
					--(Null,@Num_Proc,GETDATE(),NULL,NULL)
					select num_proc_mea,Num_Proc_HEA,Null,NULL,NULL ,GETDATE()
					from House_Exp_Aer where Num_Proc_HEA = @Num_Proc
				
		End
		
if @Num_Master is not null and @Num_Proc is null

	--set @Cd_Usuario = (Select top 1 Cd_Usuario from vwHouse_Exp where [Master] = @Num_Master)


	If  exists (select Num_Proc_Mea from Exchange_E_AirFreight where Num_Proc_Mea = @Num_Master)
		Begin
			Update
				Exchange_E_AirFreight
			Set
				Num_Proc_Mea_Dt_Envio = Null,
				Num_Proc_Mea_Dt_Ins = Getdate()
			Where
				Num_Proc_Mea = @Num_Master	                        
		End
	Else
		Begin	
			Insert
				  Exchange_E_AirFreight
			--	  (Num_Proc_Mea,Num_Proc_Hea,Num_Proc_Mea_Dt_Ins,Num_Proc_Mea_Dt_Envio,Num_Proc_Hea_Dt_Envio)
			--Values
					select num_proc_mea,Num_Proc_HEA,GETDATE(),NULL,NULL,Null
					from House_Exp_Aer where num_proc_mea = @Num_Master
				
		End

--Insert on Exchange_GT_Nexus to be sent
--BEGIN
--	insert Into Exchange_GTNexus
--	(Num_Proc,Type,Dt_Ins,Dt_Send,Cd_Usuario,Tipo_Envio	)
--	values
--	(@Num_Proc,'DE',Getdate(),NULL,isnull(@Cd_Usuario,'ATL'),9)
--END





GO
