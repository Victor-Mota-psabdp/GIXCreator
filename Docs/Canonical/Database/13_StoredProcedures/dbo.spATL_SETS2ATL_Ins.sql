SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_SETS2ATL_Ins 'DEPV','EMRHO201812007BR','05/02/2019 00:00:00'
CREATE procedure [dbo].[spATL_SETS2ATL_Ins]
(
	@Event varchar(200),
	@JOB varchar(16),
	@EventDate datetime
)
as
Begin Transaction 
	Declare @MSG varchar(400)
	Declare @Date datetime
	Declare @Modal varchar(50)
	Declare @Master_JOB varchar(14)
	If Left(@Job,1)='E'
		BEGIN
			if (@Event = 'ARRV')
				Begin
					select @Date = ATA, @Modal = Modal from vwHouse_Exp where Num_Proc = @JOB			
						if @Date is null
							BEGIN
								if @Modal = 'Ocean Export'
									Begin
										update LLP_Exp_Mar set ATA_Lem = @EventDate where Num_Proc_Lem = @JOB
									End
								if @Modal = 'Air Export'
									Begin
										update LLP_Exp_Aer set ATA_Lea = @EventDate where Num_Proc_Lea = @JOB							
									End
								if @Modal = 'Other Export'
									Begin
										update LLP_Exp_Out set ATA_Leo = @EventDate where Num_Proc_Leo = @JOB
									End
								set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
								exec spHistG_InsUPD @JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
							END
				
					select @Date = ATA_Master, @Master_JOB = Num_Proc_Master 
					from vwMaster_Exp_Completo MAS
					join vwHouse_Exp HOU on HOU.master = MAS.Num_Proc_Master 
					where HOU.Num_Proc = @JOB and MAS.Num_Proc_Master <> 'JOB'
						if @Date is null
							BEGIN
								if @Master_JOB is not null
									begin
										update LLP_Master set ATA_Master = @EventDate where Num_Proc_Master = @Master_JOB
							
										set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
										exec spHistG_InsUPD @Master_JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
									end
							END	
				End

			if (@Event = 'DEPV')
				Begin				
					select @Date = ATD, @Modal = Modal from vwHouse_Exp where Num_Proc = @JOB			
						if @Date is null
							BEGIN
								if @Modal = 'Ocean Export'
									Begin
										update LLP_Exp_Mar set ATD_Lem = @EventDate where Num_Proc_Lem = @JOB								
									End
								if @Modal = 'Air Export'
									Begin
										update LLP_Exp_Aer set ATD_Lea = @EventDate where Num_Proc_Lea = @JOB								
									End
								if @Modal = 'Other Export'
									Begin
										update LLP_Exp_Out set ATD_Leo = @EventDate where Num_Proc_Leo = @JOB
									End
								set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'							
								exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null															
							END							

					select @Date = ATD_Master, @Master_JOB = Num_Proc_Master	from vwMaster_Exp_Completo MAS
					join vwHouse_Exp HOU on HOU.master = MAS.Num_Proc_Master 
					where HOU.Num_Proc = @JOB and MAS.Num_Proc_Master <> 'JOB'
						if @Date is null
							BEGIN
								if @Master_JOB is not null
									begin
										update LLP_Master set ATD_Master = @EventDate where Num_Proc_Master = @Master_JOB
							
										set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
										exec spHistG_InsUPD @Master_JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
									end
							END						

				End
		END
	ELSE
		BEGIN
			if (@Event = 'ARRV')
				Begin
					select @Date = ATA, @Modal = Modal from vwHouse_Imp where Num_Proc = @JOB			
						if @Date is null
							Begin
								if @Modal = 'Ocean Import'
									Begin
										update LLP_Imp_Mar set ATA_Lim = @EventDate where Num_Proc_Lim = @JOB
									End
								if @Modal = 'Air Import'
									Begin
										update LLP_Imp_Aer set ATA_Lia = @EventDate where Num_Proc_Lia = @JOB
									End
								if @Modal = 'Other Export'
									Begin
										update LLP_imp_Out set ATA_Lio = @EventDate where Num_Proc_Lio = @JOB
									End
								set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
								exec spHistG_InsUPD @JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null													
							End

					select @Date = ATA_Master,@Master_JOB = Num_Proc_Master	from vwMaster_Imp_Completo MAS
					join vwHouse_Imp HOU on HOU.master = MAS.Num_Proc_Master 
					where HOU.Num_Proc = @JOB and MAS.Num_Proc_Master <> 'JOB'
						if @Date is null
							BEGIN
								if @Master_JOB is not null
									begin
										update LLP_Master set ATA_Master = @EventDate where Num_Proc_Master = @Master_JOB
							
										set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
										exec spHistG_InsUPD @Master_JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
									end
							END
				End

			if (@Event = 'DEPV')
				Begin				
					select @Date = ATD, @Modal = Modal from vwHouse_Imp where Num_Proc = @JOB			
						if @Date is null
							BEGIN
								if @Modal = 'Ocean Import'
									Begin
										update LLP_imp_Mar set ATD_Lim = @EventDate where Num_Proc_Lim = @JOB
									End
								if @Modal = 'Air Import'
									Begin
										update LLP_Imp_Aer set ATD_Lia = @EventDate where Num_Proc_Lia = @JOB
									End
								if @Modal = 'Other Import'
									Begin
										update LLP_Imp_Out set ATD_Lio = @EventDate where Num_Proc_Lio = @JOB
									End
								set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'							
								exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null													
							END

					select @Date = ATD_Master, @Master_JOB = Num_Proc_Master from vwMaster_Imp_Completo MAS
					join vwHouse_Imp HOU on HOU.master = MAS.Num_Proc_Master 
					where HOU.Num_Proc = @JOB and MAS.Num_Proc_Master <> 'JOB'
						if @Date is null
							BEGIN
								if @Master_JOB is not null
									begin
										update LLP_Master set ATD_Master = @EventDate where Num_Proc_Master = @Master_JOB
							
										set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
										exec spHistG_InsUPD @Master_JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
									end
							END
				End
	END
	

	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction


/*
--spATL_SETS2ATL_Ins 'DEPV','EMRHO201812007BR','05/02/2019 00:00:00'
ALTER procedure [dbo].[spATL_SETS2ATL_Ins]
(
	@Event varchar(200),
	@JOB varchar(16),
	@EventDate datetime
)
as
Begin Transaction 
	Declare @MSG varchar(400)
	Declare @Date datetime
	Declare @Modal varchar(50)
	If Left(@Job,1)='E'
	BEGIN
		if (@Event = 'ARRV')
			Begin
			select @Date = ATA, @Modal = Modal from vwHouse_Exp where Num_Proc = @JOB
			
				if @Date is null
					begin
						if @Modal = 'Ocean Export'
						Begin
							update LLP_Exp_Mar set ATA_Lem = @EventDate where Num_Proc_Lem = @JOB
						End
						if @Modal = 'Air Export'
						Begin
							update LLP_Exp_Aer set ATA_Lea = @EventDate where Num_Proc_Lea = @JOB
						End
						if @Modal = 'Other Export'
						Begin
							update LLP_Exp_Out set ATA_Leo = @EventDate where Num_Proc_Leo = @JOB
						End
						set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
						exec spHistG_InsUPD @JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
					End
			End

		if (@Event = 'DEPV')
			Begin
				
				select @Date = ATD, @Modal = Modal from vwHouse_Exp where Num_Proc = @JOB
			
				if @Date is null
					begin
						if @Modal = 'Ocean Export'
							Begin
								update LLP_Exp_Mar set ATD_Lem = @EventDate where Num_Proc_Lem = @JOB
							End
						if @Modal = 'Air Export'
							Begin
								update LLP_Exp_Aer set ATD_Lea = @EventDate where Num_Proc_Lea = @JOB
							End
						if @Modal = 'Other Export'
							Begin
								update LLP_Exp_Out set ATD_Leo = @EventDate where Num_Proc_Leo = @JOB
							End
						set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
						print 'Start' + @MSG 
						exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
						print 'End' + @MSG 
					End
			End
	END
	ELSE
	BEGIN
		if (@Event = 'ARRV')
			Begin
			select @Date = ATA, @Modal = Modal from vwHouse_Imp where Num_Proc = @JOB
			
				if @Date is null
					begin
						if @Modal = 'Ocean Import'
						Begin
							update LLP_Imp_Mar set ATA_Lim = @EventDate where Num_Proc_Lim = @JOB
						End
						if @Modal = 'Air Import'
						Begin
							update LLP_Imp_Aer set ATA_Lia = @EventDate where Num_Proc_Lia = @JOB
						End
						if @Modal = 'Other Export'
						Begin
							update LLP_imp_Out set ATA_Lio = @EventDate where Num_Proc_Lio = @JOB
						End
						set @MSG='ATA Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
						exec spHistG_InsUPD @JOB,Null,Null,'ATA',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
					End
			End

		if (@Event = 'DEPV')
			Begin
				
				select @Date = ATD, @Modal = Modal from vwHouse_Imp where Num_Proc = @JOB
			
				if @Date is null
					begin
						if @Modal = 'Ocean Import'
							Begin
								update LLP_imp_Mar set ATD_Lim = @EventDate where Num_Proc_Lim = @JOB
							End
						if @Modal = 'Air Import'
							Begin
								update LLP_Imp_Aer set ATD_Lia = @EventDate where Num_Proc_Lia = @JOB
							End
						if @Modal = 'Other Import'
							Begin
								update LLP_Imp_Out set ATD_Lio = @EventDate where Num_Proc_Lio = @JOB
							End
						set @MSG='ATD Updated from SETS = ' + convert(varchar(10),@EventDate,105) + space(10) + 'Historic created by ATL System'
						print 'Start' + @MSG 
						exec spHistG_InsUPD @JOB,Null,Null,'ATD',@MSG,'01-01-2010',Null,'ATL System','N','U',Null
						print 'End' + @MSG 
					End
			End
	END
	

	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction 
	
*/
GO
